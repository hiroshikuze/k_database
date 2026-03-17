import { serve } from "@hono/node-server";
import { serveStatic } from "@hono/node-server/serve-static";
import { Hono } from "hono";
import { cors } from "hono/cors";
import { logger } from "hono/logger";
import { db, runMigrations } from "./db/index.js";
import { customersRoute } from "./routes/customers.js";
import { historyRoute } from "./routes/history.js";

// マイグレーション実行
runMigrations();

const app = new Hono();

app.use(logger());
app.use(
  "/api/*",
  cors({
    origin: process.env.NODE_ENV === "production" ? false : "http://localhost:5173",
  }),
);

// APIルート
app.route("/api/customers", customersRoute);
app.route("/api/history", historyRoute);

// ヘルスチェック
app.get("/api/health", (c) => c.json({ status: "ok" }));

// 本番環境：Reactビルド済み静的ファイルを配信
if (process.env.NODE_ENV === "production") {
  app.use("/*", serveStatic({ root: "./dist/public" }));
  app.get("*", serveStatic({ path: "./dist/public/index.html" }));
}

const port = parseInt(process.env.PORT ?? "3000");
console.log(`サーバー起動: http://localhost:${port}`);

serve({ fetch: app.fetch, port });
