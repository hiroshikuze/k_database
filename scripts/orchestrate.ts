/**
 * k_database rebuild orchestrator
 *
 * Workflow:
 *   Phase 1: Doc agent  — generates specs from CLAUDE.md
 *   Phase 2: Parallel   — DB / API / UI / Test agents run concurrently
 *   Phase 3: Per-agent  — tests run after each agent finishes; failures trigger a fix loop
 *
 * Usage:
 *   npx tsx scripts/orchestrate.ts
 *
 * Requirements:
 *   npm install @anthropic-ai/claude-agent-sdk tsx
 *   ANTHROPIC_API_KEY env var must be set
 */

import { query, ResultMessage } from "@anthropic-ai/claude-agent-sdk";
import { execSync } from "child_process";
import * as fs from "fs";
import * as path from "path";

const CWD = path.resolve(__dirname, "..");
const SPEC_FILE = path.join(CWD, "docs/generated-spec.md");
const MAX_FIX_ATTEMPTS = 3;

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

async function runAgent(
  label: string,
  prompt: string,
  extraTools: string[] = []
): Promise<string> {
  console.log(`\n[${label}] starting...`);
  let result = "";
  for await (const msg of query({
    prompt,
    options: {
      cwd: CWD,
      allowedTools: ["Read", "Write", "Edit", "Glob", "Grep", "Bash", ...extraTools],
      permissionMode: "acceptEdits",
      model: "claude-opus-4-6",
      maxTurns: 80,
    },
  })) {
    if ("result" in msg) {
      result = (msg as ResultMessage).result ?? "";
    }
  }
  console.log(`[${label}] done.`);
  return result;
}

function runTests(): { ok: boolean; output: string } {
  try {
    const output = execSync("npm test -- --passWithNoTests 2>&1", {
      cwd: CWD,
      encoding: "utf8",
      timeout: 120_000,
    });
    return { ok: true, output };
  } catch (e: any) {
    return { ok: false, output: e.stdout ?? e.message };
  }
}

async function fixLoop(agentLabel: string, testOutput: string): Promise<void> {
  for (let attempt = 1; attempt <= MAX_FIX_ATTEMPTS; attempt++) {
    console.log(`\n[${agentLabel}] fix attempt ${attempt}/${MAX_FIX_ATTEMPTS}`);
    await runAgent(
      `${agentLabel}-fix-${attempt}`,
      `テストが失敗しています。以下のエラーを修正してください。
テスト出力:
\`\`\`
${testOutput}
\`\`\`
関連するソースファイルを読み、最小限の変更で修正してください。`
    );
    const result = runTests();
    if (result.ok) {
      console.log(`[${agentLabel}] tests passing after fix ${attempt}`);
      return;
    }
    testOutput = result.output;
  }
  console.warn(`[${agentLabel}] tests still failing after ${MAX_FIX_ATTEMPTS} fix attempts.`);
}

// ---------------------------------------------------------------------------
// Phase 1: Documentation / specification agent
// ---------------------------------------------------------------------------

async function phaseDoc(): Promise<string> {
  const claudeMd = fs.readFileSync(path.join(CWD, "CLAUDE.md"), "utf8");

  await runAgent(
    "doc-agent",
    `あなたは設計ドキュメント作成エージェントです。
以下の旧システム仕様（CLAUDE.md）を読み、Next.js + TypeScript + SQLite(Prisma) + Tailwind CSS + shadcn/ui で
作り直す場合の設計ドキュメントを docs/generated-spec.md に生成してください。

## 旧仕様
${claudeMd}

## 生成するドキュメントの構成
1. システム概要と技術スタック
2. データモデル（Prismaスキーマ定義）
3. APIエンドポイント一覧（Next.js App Router形式）
4. 画面・コンポーネント一覧
5. 認証方式（パスキー / SimpleWebAuthn）
6. i18n方針（next-i18next, ja/en）
7. PWA設定方針
8. Docker Compose構成
9. テスト方針（Vitest + React Testing Library）
10. ディレクトリ構造

必ず docs/generated-spec.md として保存してください。`
  );

  return fs.existsSync(SPEC_FILE)
    ? fs.readFileSync(SPEC_FILE, "utf8")
    : "(spec not generated)";
}

// ---------------------------------------------------------------------------
// Phase 2: Parallel implementation agents
// ---------------------------------------------------------------------------

async function agentDB(spec: string): Promise<void> {
  await runAgent(
    "db-agent",
    `あなたはデータベース設計エージェントです。
以下の設計仕様を元に、Prismaスキーマとマイグレーション、seedスクリプトを実装してください。

## 仕様
${spec}

## タスク
- prisma/schema.prisma を作成
- prisma/seed.ts を作成（サンプルデータ10件）
- src/lib/db.ts（PrismaClientシングルトン）を作成
- 各モデルのCRUD関数を src/lib/ に作成
テストは __tests__/db/ に Vitest で作成してください。`
  );

  const { ok, output } = runTests();
  if (!ok) await fixLoop("db-agent", output);
}

async function agentAPI(spec: string): Promise<void> {
  await runAgent(
    "api-agent",
    `あなたはAPIエージェントです。
以下の設計仕様を元に、Next.js App Router の Route Handlers を実装してください。

## 仕様
${spec}

## タスク
- src/app/api/ 配下に REST エンドポイントを実装
- Zodによるリクエストバリデーション
- エラーハンドリング（400/401/404/500）
- src/lib/auth/ にSimpleWebAuthnを使ったパスキー認証を実装
テストは __tests__/api/ に Vitest で作成してください。`
  );

  const { ok, output } = runTests();
  if (!ok) await fixLoop("api-agent", output);
}

async function agentUI(spec: string): Promise<void> {
  await runAgent(
    "ui-agent",
    `あなたはフロントエンドエージェントです。
以下の設計仕様を元に、React + Tailwind CSS + shadcn/ui でUIコンポーネントと画面を実装してください。

## 仕様
${spec}

## タスク
- src/components/ に再利用可能なコンポーネントを実装
- src/app/ に各画面を実装（App Router）
- next-i18next で ja/en 対応（messages/ja.json, messages/en.json）
- スマートフォン対応のレスポンシブレイアウト
- next-pwa でPWA対応（next.config.ts に設定）
- データ取得はSWR or React Query でAJAX化
テストは __tests__/ui/ に React Testing Library + Vitest で作成してください。`
  );

  const { ok, output } = runTests();
  if (!ok) await fixLoop("ui-agent", output);
}

async function agentTest(spec: string): Promise<void> {
  await runAgent(
    "test-agent",
    `あなたはテストエンジニアエージェントです。
以下の設計仕様を元に、Vitestを使ったテストスイートを先行して作成してください。

## 仕様
${spec}

## タスク
- vitest.config.ts を作成
- __tests__/ 配下にユニットテスト・統合テストを作成
  - DB層: モックを使ったCRUDテスト
  - API層: リクエスト/レスポンス検証テスト
  - UI層: コンポーネントレンダリングテスト
  - E2Eシナリオ: 顧客検索→詳細→更新フロー
- テストヘルパー（fixtures, factories）を __tests__/helpers/ に作成
まだ実装がない場合はスキップ扱いにしてください（vi.skip or beforeAll でチェック）。`
  );
}

// ---------------------------------------------------------------------------
// Main
// ---------------------------------------------------------------------------

async function main() {
  console.log("=== k_database rebuild orchestrator ===\n");

  // Phase 1
  console.log("--- Phase 1: Documentation ---");
  const spec = await phaseDoc();
  console.log(`Spec written to: ${SPEC_FILE}`);

  // Phase 2: All 4 agents in parallel
  console.log("\n--- Phase 2: Parallel implementation ---");
  await Promise.all([
    agentDB(spec),
    agentAPI(spec),
    agentUI(spec),
    agentTest(spec),
  ]);

  // Final test run
  console.log("\n--- Final test run ---");
  const { ok, output } = runTests();
  if (ok) {
    console.log("All tests passing. Build complete.");
  } else {
    console.warn("Some tests still failing:\n", output);
  }
}

main().catch(console.error);
