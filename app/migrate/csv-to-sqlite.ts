/**
 * CSV → SQLite 移行スクリプト
 *
 * 使い方:
 *   npm run migrate:csv -- --kokyaku=../src/kokyaku.csv --taiou=../src/taiou.csv
 *
 * 注意:
 *   - 元CSVはEUC-JPエンコードです。iconv等で事前にUTF-8変換してください:
 *     iconv -f EUC-JP -t UTF-8 kokyaku.csv > kokyaku_utf8.csv
 *   - 先頭行はヘッダー行です（スキップします）
 */

import { readFileSync } from "node:fs";
import Database from "better-sqlite3";
import { drizzle } from "drizzle-orm/better-sqlite3";
import { migrate } from "drizzle-orm/better-sqlite3/migrator";
import { mkdirSync } from "node:fs";
import { customers, history } from "../src/server/db/schema.js";

const args = process.argv.slice(2);
const argMap = Object.fromEntries(
  args.map((a) => a.replace(/^--/, "").split("=")),
);

const kokyakuPath = argMap["kokyaku"] ?? "../src/kokyaku.csv";
const taiouPath = argMap["taiou"] ?? "../src/taiou.csv";
const dbPath = argMap["db"] ?? "./data/k_database.db";

mkdirSync("./data", { recursive: true });

const sqlite = new Database(dbPath);
sqlite.pragma("journal_mode = WAL");
sqlite.pragma("foreign_keys = ON");
const db = drizzle(sqlite);

// マイグレーション実行（テーブルが無ければ作成）
migrate(db, { migrationsFolder: "./src/server/db/migrations" });

function splitTsv(line: string): string[] {
  return line.split("\t").map((v) => v.trim());
}

// ---- kokyaku.csv の移行 ----
console.log(`\n顧客データ移行: ${kokyakuPath}`);
let kokyakuLines: string[] = [];
try {
  kokyakuLines = readFileSync(kokyakuPath, "utf-8").split("\n");
} catch {
  console.warn("  ファイルが見つかりません。スキップします。");
}

let kokyakuCount = 0;
// 1行目がヘッダーなのでスキップ
for (const line of kokyakuLines.slice(1)) {
  if (!line.trim()) continue;
  const f = splitTsv(line);
  // フィールド順（元のPerl実装から）:
  // [0]=ID [1]=分類 [2]=会社名 [3]=会社名ふりがな [4]=部署 [5]=部署ふりがな
  // [6]=支店 [7]=支店ふりがな [8]=支店部署 [9]=担当者 [10]=担当者ふりがな
  // [11]=郵便番号 [12]=住所 [13]=住所2-郵便番号 [14]=住所2
  // [15]=TEL [16]=FAX [17]=E-Mail [18]=開業月 [19]=開業年月
  // [20]=業種区分 [21]=従業員数 [22]=地域 [23]=業態 [24]=主要商品
  // [25]=プライベート名 [26]=Website [27]=担当者 [28]=ステータス
  // [29]=PC種 [30]=LAN環境 [31]=環境担当者名 [32]=備考
  try {
    db.insert(customers).values({
      legacyId: f[0] ? parseInt(f[0]) : undefined,
      classification: f[1] ?? "",
      companyName: f[2] ?? "",
      companyNameKana: f[3] ?? "",
      department: f[4] ?? "",
      departmentKana: f[5] ?? "",
      branch: f[6] ?? "",
      branchKana: f[7] ?? "",
      branchDepartment: f[8] ?? "",
      contactName: f[9] ?? "",
      contactNameKana: f[10] ?? "",
      postalCode: f[11] ?? "",
      address: f[12] ?? "",
      postalCode2: f[13] ?? "",
      address2: f[14] ?? "",
      tel: f[15] ?? "",
      fax: f[16] ?? "",
      email: f[17] ?? "",
      establishedMonth: f[18] ?? "",
      establishedYear: f[19] ?? "",
      businessType: f[20] ?? "",
      employeeCount: f[21] ?? "",
      region: f[22] ?? "",
      industry: f[23] ?? "",
      mainProducts: f[24] ?? "",
      privateName: f[25] ?? "",
      website: f[26] ?? "",
      manager: f[27] ?? "",
      status: f[28] ?? "",
      pcType: f[29] ?? "",
      lanEnv: f[30] ?? "",
      envContactName: f[31] ?? "",
      note: f[32] ?? "",
    }).run();
    kokyakuCount++;
  } catch (e) {
    console.warn(`  行スキップ: ${(e as Error).message} | ${line.slice(0, 60)}`);
  }
}
console.log(`  ${kokyakuCount}件 移行完了`);

// ---- taiou.csv の移行 ----
console.log(`\n対応履歴移行: ${taiouPath}`);
let taiouLines: string[] = [];
try {
  taiouLines = readFileSync(taiouPath, "utf-8").split("\n");
} catch {
  console.warn("  ファイルが見つかりません。スキップします。");
}

// legacyId → 新しいcustomers.id のマッピング
const legacyToNew = new Map<number, number>();
const allCustomers = db.select({ id: customers.id, legacyId: customers.legacyId }).from(customers).all();
for (const c of allCustomers) {
  if (c.legacyId != null) legacyToNew.set(c.legacyId, c.id);
}

let taiouCount = 0;
// [0]=管理ID [1]=顧客ID(legacyId) [2]=顧客名 [3]=担当者名 [4]=対応種別 [5]=日時 [6]=内容
for (const line of taiouLines.slice(1)) {
  if (!line.trim()) continue;
  const f = splitTsv(line);
  const legacyCustomerId = f[1] ? parseInt(f[1]) : null;
  const customerId = legacyCustomerId ? legacyToNew.get(legacyCustomerId) : null;
  if (!customerId) {
    console.warn(`  顧客ID不明でスキップ: legacyId=${legacyCustomerId}`);
    continue;
  }
  try {
    db.insert(history).values({
      legacyId: f[0] ? parseInt(f[0]) : undefined,
      customerId,
      customerName: f[2] ?? "",
      managerName: f[3] ?? "",
      interactionType: f[4] ?? "",
      occurredAt: f[5] ?? "",
      content: f[6] ?? "",
    }).run();
    taiouCount++;
  } catch (e) {
    console.warn(`  行スキップ: ${(e as Error).message}`);
  }
}
console.log(`  ${taiouCount}件 移行完了`);
console.log("\n移行が完了しました。");
