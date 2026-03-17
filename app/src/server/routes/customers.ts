import { Hono } from "hono";
import { zValidator } from "@hono/zod-validator";
import { z } from "zod";
import { db } from "../db/index.js";
import { customers } from "../db/schema.js";
import { eq, like, or, sql } from "drizzle-orm";

export const customersRoute = new Hono();

const customerSchema = z.object({
  classification: z.string().max(50).default(""),
  companyName: z.string().max(200).default(""),
  companyNameKana: z.string().max(200).default(""),
  department: z.string().max(100).default(""),
  departmentKana: z.string().max(100).default(""),
  branch: z.string().max(100).default(""),
  branchKana: z.string().max(100).default(""),
  branchDepartment: z.string().max(100).default(""),
  contactName: z.string().max(100).default(""),
  contactNameKana: z.string().max(100).default(""),
  postalCode: z.string().max(10).default(""),
  address: z.string().max(300).default(""),
  postalCode2: z.string().max(10).default(""),
  address2: z.string().max(300).default(""),
  tel: z.string().max(30).default(""),
  fax: z.string().max(30).default(""),
  email: z.string().max(200).default(""),
  establishedMonth: z.string().max(20).default(""),
  establishedYear: z.string().max(20).default(""),
  businessType: z.string().max(100).default(""),
  employeeCount: z.string().max(30).default(""),
  region: z.string().max(100).default(""),
  industry: z.string().max(100).default(""),
  mainProducts: z.string().max(300).default(""),
  privateName: z.string().max(100).default(""),
  website: z.string().max(300).default(""),
  manager: z.string().max(100).default(""),
  status: z.string().max(50).default(""),
  pcType: z.string().max(100).default(""),
  lanEnv: z.string().max(100).default(""),
  envContactName: z.string().max(100).default(""),
  note: z.string().max(2000).default(""),
  displayFlag: z.boolean().default(true),
  mainCustomer: z.boolean().default(false),
});

// 一覧取得（検索・ページネーション付き）
customersRoute.get("/", async (c) => {
  const { q, page = "1", limit = "30" } = c.req.query();
  const pageNum = Math.max(1, parseInt(page));
  const limitNum = Math.min(100, Math.max(1, parseInt(limit)));
  const offset = (pageNum - 1) * limitNum;

  let query = db.select().from(customers);

  if (q && q.trim()) {
    const keyword = `%${q.trim()}%`;
    query = query.where(
      or(
        like(customers.companyName, keyword),
        like(customers.companyNameKana, keyword),
        like(customers.contactName, keyword),
        like(customers.tel, keyword),
        like(customers.email, keyword),
        like(customers.address, keyword),
      ),
    ) as typeof query;
  }

  const [rows, countResult] = await Promise.all([
    query.limit(limitNum).offset(offset),
    db
      .select({ count: sql<number>`count(*)` })
      .from(customers)
      .where(
        q && q.trim()
          ? or(
              like(customers.companyName, `%${q.trim()}%`),
              like(customers.companyNameKana, `%${q.trim()}%`),
              like(customers.contactName, `%${q.trim()}%`),
              like(customers.tel, `%${q.trim()}%`),
              like(customers.email, `%${q.trim()}%`),
              like(customers.address, `%${q.trim()}%`),
            )
          : undefined,
      ),
  ]);

  return c.json({
    data: rows,
    total: countResult[0]?.count ?? 0,
    page: pageNum,
    limit: limitNum,
  });
});

// 詳細取得
customersRoute.get("/:id", async (c) => {
  const id = parseInt(c.req.param("id"));
  if (isNaN(id)) return c.json({ error: "不正なIDです" }, 400);

  const row = await db
    .select()
    .from(customers)
    .where(eq(customers.id, id))
    .get();

  if (!row) return c.json({ error: "顧客が見つかりません" }, 404);
  return c.json(row);
});

// 新規作成
customersRoute.post(
  "/",
  zValidator("json", customerSchema),
  async (c) => {
    const data = c.req.valid("json");
    const result = await db
      .insert(customers)
      .values(data)
      .returning()
      .get();
    return c.json(result, 201);
  },
);

// 更新
customersRoute.put(
  "/:id",
  zValidator("json", customerSchema),
  async (c) => {
    const id = parseInt(c.req.param("id"));
    if (isNaN(id)) return c.json({ error: "不正なIDです" }, 400);

    const data = c.req.valid("json");
    const result = await db
      .update(customers)
      .set({ ...data, updatedAt: sql`(datetime('now', 'localtime'))` })
      .where(eq(customers.id, id))
      .returning()
      .get();

    if (!result) return c.json({ error: "顧客が見つかりません" }, 404);
    return c.json(result);
  },
);

// 削除
customersRoute.delete("/:id", async (c) => {
  const id = parseInt(c.req.param("id"));
  if (isNaN(id)) return c.json({ error: "不正なIDです" }, 400);

  await db.delete(customers).where(eq(customers.id, id));
  return c.json({ success: true });
});
