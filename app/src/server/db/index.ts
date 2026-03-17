import Database from "better-sqlite3";
import { drizzle } from "drizzle-orm/better-sqlite3";
import { migrate } from "drizzle-orm/better-sqlite3/migrator";
import { mkdirSync } from "node:fs";
import { dirname } from "node:path";
import * as schema from "./schema.js";

const dbPath = process.env.DB_PATH ?? "./data/k_database.db";

// データディレクトリを自動作成
mkdirSync(dirname(dbPath), { recursive: true });

const sqlite = new Database(dbPath);
sqlite.pragma("journal_mode = WAL");
sqlite.pragma("foreign_keys = ON");

export const db = drizzle(sqlite, { schema });

// マイグレーションを自動実行
export function runMigrations() {
  migrate(db, { migrationsFolder: "./src/server/db/migrations" });
}
