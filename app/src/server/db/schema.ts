import { integer, sqliteTable, text } from "drizzle-orm/sqlite-core";
import { sql } from "drizzle-orm";

// 顧客マスター (kokyaku.csv の移行先)
export const customers = sqliteTable("customers", {
  id: integer("id").primaryKey({ autoIncrement: true }),
  // 元CSVのID（タイムスタンプ由来）を保持。移行時に使用
  legacyId: integer("legacy_id").unique(),

  classification: text("classification").default(""),      // 分類
  companyName: text("company_name").notNull().default(""), // 会社名
  companyNameKana: text("company_name_kana").default(""),  // 会社名ふりがな
  department: text("department").default(""),              // 部署
  departmentKana: text("department_kana").default(""),     // 部署ふりがな
  branch: text("branch").default(""),                      // 支店名
  branchKana: text("branch_kana").default(""),             // 支店名ふりがな
  branchDepartment: text("branch_department").default(""), // 支店部署名
  contactName: text("contact_name").default(""),           // 担当者名
  contactNameKana: text("contact_name_kana").default(""),  // 担当者ふりがな
  postalCode: text("postal_code").default(""),             // 郵便番号
  address: text("address").default(""),                    // 住所
  postalCode2: text("postal_code2").default(""),           // 住所2-郵便番号
  address2: text("address2").default(""),                  // 住所2
  tel: text("tel").default(""),                            // TEL
  fax: text("fax").default(""),                            // FAX
  email: text("email").default(""),                        // E-Mail
  establishedMonth: text("established_month").default(""), // 開業月
  establishedYear: text("established_year").default(""),   // 開業年月
  businessType: text("business_type").default(""),         // 業種区分
  employeeCount: text("employee_count").default(""),       // 従業員数
  region: text("region").default(""),                      // 地域
  industry: text("industry").default(""),                  // 業態
  mainProducts: text("main_products").default(""),         // 主要商品
  privateName: text("private_name").default(""),           // プライベート名
  website: text("website").default(""),                    // Website
  manager: text("manager").default(""),                    // 担当者
  status: text("status").default(""),                      // ステータス
  pcType: text("pc_type").default(""),                     // PC種
  lanEnv: text("lan_env").default(""),                     // LAN環境
  envContactName: text("env_contact_name").default(""),    // 環境担当者名
  note: text("note").default(""),                          // 備考
  displayFlag: integer("display_flag", { mode: "boolean" }).default(true),
  mainCustomer: integer("main_customer", { mode: "boolean" }).default(false),

  createdAt: text("created_at").default(sql`(datetime('now', 'localtime'))`),
  updatedAt: text("updated_at").default(sql`(datetime('now', 'localtime'))`),
});

// 対応履歴 (taiou.csv の移行先)
export const history = sqliteTable("history", {
  id: integer("id").primaryKey({ autoIncrement: true }),
  legacyId: integer("legacy_id"),

  customerId: integer("customer_id")
    .notNull()
    .references(() => customers.id, { onDelete: "cascade" }),
  customerName: text("customer_name").default(""),  // 顧客名（非正規化・検索用）
  managerName: text("manager_name").default(""),    // 担当者名
  interactionType: text("interaction_type").default(""), // 対応種別
  occurredAt: text("occurred_at").default(""),      // 対応日時
  content: text("content").default(""),             // 内容

  createdAt: text("created_at").default(sql`(datetime('now', 'localtime'))`),
});

// 操作履歴 (sousa_rireki.csv の移行先)
export const auditLog = sqliteTable("audit_log", {
  id: integer("id").primaryKey({ autoIncrement: true }),
  operation: text("operation").notNull(), // 操作種別
  targetId: integer("target_id"),         // 対象顧客ID
  detail: text("detail").default(""),     // 詳細
  operatorName: text("operator_name").default(""),
  createdAt: text("created_at").default(sql`(datetime('now', 'localtime'))`),
});

export type Customer = typeof customers.$inferSelect;
export type NewCustomer = typeof customers.$inferInsert;
export type History = typeof history.$inferSelect;
export type NewHistory = typeof history.$inferInsert;
