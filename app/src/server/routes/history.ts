import { Hono } from "hono";
import { zValidator } from "@hono/zod-validator";
import { z } from "zod";
import { db } from "../db/index.js";
import { history, customers } from "../db/schema.js";
import { eq, desc } from "drizzle-orm";

export const historyRoute = new Hono();

const historySchema = z.object({
  customerId: z.number().int().positive(),
  managerName: z.string().max(100).default(""),
  interactionType: z.string().max(50).default(""),
  occurredAt: z.string().max(50).default(""),
  content: z.string().max(2000).default(""),
});

// 顧客の対応履歴一覧
historyRoute.get("/customer/:customerId", async (c) => {
  const customerId = parseInt(c.req.param("customerId"));
  if (isNaN(customerId)) return c.json({ error: "不正なIDです" }, 400);

  const rows = await db
    .select()
    .from(history)
    .where(eq(history.customerId, customerId))
    .orderBy(desc(history.createdAt));

  return c.json(rows);
});

// 履歴追加
historyRoute.post(
  "/",
  zValidator("json", historySchema),
  async (c) => {
    const data = c.req.valid("json");

    // 顧客名を取得して非正規化保存
    const customer = await db
      .select({ companyName: customers.companyName })
      .from(customers)
      .where(eq(customers.id, data.customerId))
      .get();

    const result = await db
      .insert(history)
      .values({ ...data, customerName: customer?.companyName ?? "" })
      .returning()
      .get();

    return c.json(result, 201);
  },
);

// 履歴削除
historyRoute.delete("/:id", async (c) => {
  const id = parseInt(c.req.param("id"));
  if (isNaN(id)) return c.json({ error: "不正なIDです" }, 400);

  await db.delete(history).where(eq(history.id, id));
  return c.json({ success: true });
});
