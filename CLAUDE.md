# CLAUDE.md — k_database AIアシスタントガイド

---

## プロジェクト概要

**k_database** は Perl 製の軽量 CGI ベース顧客管理システム（CRM）。小規模組織向けに顧客データと対応履歴を管理する。UI・コメントは主に**日本語**。

- **言語**: Perl 5（手続き型、OOP なし）
- **アーキテクチャ**: CGI Web アプリケーション（フレームワークなし）
- **データ保存**: フラット CSV ファイル（SQL データベースなし）
- **文字コード**: EUC-JP（JIS/SJIS 変換ユーティリティあり）
- **作者**: hiroshikuze
- **ライセンス**: カスタム（LICENCE.md 参照）— 帰属表示付きで利用・改変自由

---

## リポジトリ構造

```
k_database/
├── .gitignore              # ランタイム生成の *.bak を除外
├── README.md               # プロジェクト概要
├── LICENCE.md              # ライセンス条項（日本語）
├── CLAUDE.md               # このファイル
├── docs/                   # GitHub Pages ソース
│   ├── index.html          # トップページ
│   ├── info_program.html   # プログラム構造ドキュメント
│   ├── info_use.html       # 使用マニュアル
│   └── info_supports.html  # サポート・著作権情報
└── src/                    # デプロイ対象（Web サーバーにこのディレクトリをコピー）
    ├── index.cgi           # メインコントローラー（$sw によるルーティング）
    ├── downdata.cgi        # Excel/CSV データエクスポート
    ├── dummy.cgi           # HTTP_REFERER セキュリティ検証
    ├── config.dat          # バイナリ設定ファイル（Perl シリアライズ）
    ├── kokyaku.csv         # 顧客マスター（タブ区切り）
    ├── taiou.csv           # 対応履歴ログ
    ├── sousa_rireki.csv    # 操作監査ログ
    └── *.pl                # Perl ライブラリモジュール・機能サブルーチン（フラット配置）
```

> `*.bak` はランタイム生成バックアップ — `.gitignore` で除外済み。
> `*.pl` は `src/` 直下にフラット配置。`require 'lib.pl'` のパスが通るよう**サブディレクトリに移動しないこと**。

---

## ソースファイル一覧

### エントリーポイント

| ファイル | 役割 |
|---------|------|
| `index.cgi` | メインコントローラー。`$sw` ステート変数で画面ルーティング |
| `downdata.cgi` | 顧客データをタブ区切りファイルとして Excel 向けにエクスポート |
| `dummy.cgi` | HTTP_REFERER を検証し、直接アクセスをブロック |

### コアライブラリ（`*_lib.pl`）

| ファイル | 役割 |
|---------|------|
| `form_lib.pl` | CGI POST/GET フォームデータを `%form` ハッシュにパース、HTML タグ除去 |
| `jcode.pl` | 日本語文字コード変換（EUC/JIS/SJIS）— サードパーティ |
| `file_access_lib.pl` | `flock` ベースのロック付き CSV ファイル I/O |
| `output_sub.pl` | HTML 出力ヘルパーとページテンプレート |
| `options_lib.pl` | フォーム用 `<select>` ドロップダウンのオプションリスト生成 |
| `tab_cut_lib.pl` | タブ区切り CSV 行を `@cut_end` 配列に分割 |
| `debug_lib.pl` | ファイルへのデバッグログ出力 |
| `encodesubject_lib.pl` | メール件名ヘッダーの RFC2047 BASE64 エンコード |
| `seiri_formdata_lib.pl` | フォーム入力データの正規化・クリーニング |
| `save_kanri_rireki_lib.pl` | 管理・監査履歴エントリの記録 |

### 機能モジュール

| 機能領域 | ファイル |
|---------|---------|
| 顧客検索 | `search_sub.pl` |
| 顧客編集 | `edit_check_sub.pl`, `edit_save_sub.pl`, `edit_rireki_sub.pl` |
| 顧客詳細表示 | `syousai_sub.pl`, `html_syousai0_sub.pl`, `html_syousai1_sub.pl`, `html_syousai2_sub.pl` |
| 対応履歴 | `save_rireki_sub.pl`, `html_check_sousarireki_sub.pl` |
| メール | `edit_sendmail_naiyou_sub.pl`, `edit_sendmail_send_sub.pl`, `html_mail_kakunin_sub.pl`, `html_mail_naiyou_sub.pl` |
| 管理・設定 | `master_edit_info_sub.pl`, `master_check_edit_sub.pl`, `master_setting_change_sub.pl`, `master_switch_sub.pl`, `html_kanrimode_switch_sub.pl` |

### ファイル命名規則

- `html_*_sub.pl` — 特定画面の HTML レンダリング・出力
- `edit_*_sub.pl` — データ編集・保存処理
- `master_*_sub.pl` — 管理・設定機能
- `*_lib.pl` — 再利用可能なユーティリティライブラリ
- `*_rireki*` — 履歴・監査ログ関連ロジック

---

## データモデル（CSV スキーマ）

### `kokyaku.csv` — 顧客マスター（約33フィールド、タブ区切り）

主要フィールド（位置指定、タブ区切り、データ行にヘッダーなし）:
- 顧客ID、分類、会社名、会社名（ふりがな）
- 部署、部門、郵便番号、住所
- 電話、FAX、メール、Web サイト
- 従業員数、業種カテゴリ、地域、ステータス

### `taiou.csv` — 対応・連絡ログ（約6〜7フィールド）

- 管理ID、顧客ID、顧客名
- 担当者名、対応種別、日時、備考

### `sousa_rireki.csv` — 操作監査ログ

顧客レコードの作成・更新・削除操作を追跡。

**重要**: 全データファイルの区切り文字はカンマではなくタブ（`\t`）。保存操作の前に自動で `*.bak` ファイルにバックアップが書き込まれる。

---

## アーキテクチャパターン

### リクエストルーティング

`index.cgi` は `$sw`（スイッチ）変数をステートマシンとして使用。各ステート値が画面またはアクションに対応:

```perl
if ($sw eq "some_state") {
    require "./some_sub.pl";
    &some_subroutine();
}
```

### フォーム処理

フォームデータは `form_lib.pl` がグローバルな `%form` ハッシュにパース:

```perl
require "./form_lib.pl";
&form_parse();       # %form を生成
$form{'fieldname'}   # フィールドへのアクセス
```

### ファイル I/O

全 CSV アクセスはファイルロック付きの `file_access_lib.pl` 経由:

```perl
require "./file_access_lib.pl";
&file_access("<$filename", $error_code);   # 読み込み
&file_access(">$filename", $error_code);   # 書き込み（上書き）
```

### タブ区切りパース

CSV 行読み込み後、`tab_cut_lib.pl` でフィールドをパース:

```perl
require "./tab_cut_lib.pl";
&tab_cut($line);   # @cut_end 配列を生成
$cut_end[0]        # 1番目のフィールド
$cut_end[1]        # 2番目のフィールド、など
```

---

## 開発規約

### コードスタイル

- 純粋な手続き型 Perl — 古いファイルには `use strict` / `use warnings` なし
- モジュールは `require`（`use` ではない）で読み込み — ランタイムロード
- グローバル変数を多用 — 意図しない副作用に注意
- 日本語の変数名・コメントは一般的で期待される
- サブルーチンはプロトタイプなしで `sub funcname { ... }` と定義

### 文字コード

- ソースファイルとデータは **EUC-JP** エンコード
- 変換が必要な場合は `jcode.pl` を使用
- ファイル編集時は既存のエンコードを維持 — プロジェクト全体の変換指示がない限り UTF-8 で保存しないこと

### セキュリティ

- `form_lib.pl` で HTML 入力をサニタイズ（XSS 対策）
- 管理モードはソルト `"cr"` を使った `crypt()` でパスワード保護
- `dummy.cgi` が一部ページの `HTTP_REFERER` を検証
- **CSRF 保護なし** — フォームベースのアクション追加時に注意
- コードは 2002〜2005 年のもの — 公開デプロイ時はモダンなセキュリティ対策を適用すること

### ビルドステップなし・テストなし

- 純粋な CGI スクリプト — コンパイル・バンドラー・トランスパイラなし
- **自動テストスイートなし** — 全検証は手動（Web サーバー環境で CGI スクリプトを実行して確認）
- デプロイ: `src/` 全体を CGI 有効な Web ディレクトリにコピー → `*.cgi` に実行権限（`chmod 755`）→ `*.csv` / `*.bak` への書き込み権限を付与

### 設定ファイル（`config.dat`）

Perl シリアライズのバイナリファイル。文字コード設定・ページネーション・Sendmail/SMTP 設定・管理者パスワード（crypt ハッシュ）を保持。**テキストファイルとして直接編集しないこと。** 管理 UI 経由、または `Storable` を使った Perl スクリプトで変更する。

---

## AIアシスタント向け注意事項

1. **配置場所** — ソースは `src/`、ドキュメントは `docs/`。ファイル作成・編集時は正しいディレクトリに配置すること
2. **日本語コンテンツはそのまま** — ユーザーが明示的に求めない限り、日本語文字列を英語に置き換えないこと
3. **EUC-JP エンコード** — 日本語文字を含むファイルの変更時は注意
4. **グローバル状態** — 共有変数（`%form`、`@cut_end` など）の変更はリクエスト全体に影響する
5. **ファイルロック必須** — CSV I/O は必ず `file_access_lib.pl` を使用。直接ファイルアクセスはロックをバイパスしてデータ破損のリスクがある
6. **バックアップファイル** — `*.bak` は自動生成・gitignore 済み。コミットしないこと
7. **CGI 環境** — コードは Web サーバー下で動作。`STDIN`、`STDOUT`、`QUERY_STRING` 等の環境変数が I/O チャネル
8. **旧 Perl イディオム** — 現代化を求められない限り、既存スタイルとの一貫性を優先すること
9. **`require` パス** — 全 `*.pl` は `src/` 直下にフラット。`index.cgi` 等の `require` 呼び出しを全て更新せずにサブディレクトリへ移動しないこと
10. **セッション記録** — 重要な実装・決定事項は末尾の「セッション記録」セクションに随時追記すること。ユーザーから「CLAUDE.mdに記録して」と言われたら、以下の形式で追記する:
    ```
    ### YYYY-MM-DD セッション
    - 実施内容: ...
    - 技術的決定: ...
    - 関連ファイル: ...
    ```

---

## セッション記録

### 2026-03-17 セッション
- 実施内容: Perlベース旧CRMをTypeScript+SQLite構成でフルリビルド（`app/` ディレクトリ以下）
- 技術的決定:
  - バックエンド: **Hono + TypeScript**（REST API、ポート3000）
  - フロントエンド: **React + Vite**（SPA、ポート5173）
  - DB: **Drizzle ORM + SQLite**（WALモード）、バリデーションにZod使用
  - kokyaku.csv / taiou.csv → SQLite への移行スクリプトも実装
  - 開発: `npm run dev`、本番: `npm run build && npm start`
- 関連ファイル: `app/src/server/`, `app/src/client/`, `app/migrate/csv-to-sqlite.ts`, `app/src/server/db/schema.ts`

### 2026-03-17 セッション
- 実施内容: CLAUDE.md を日本語化・整理。ワークフロー手順を `.claude/commands/` にスラッシュコマンドとして分離
- 技術的決定: CLAUDE.md はコンテキスト情報のみ残し、定型作業手順は `.claude/commands/` に移動
- 関連ファイル: `CLAUDE.md`, `.claude/commands/add-screen.md`, `.claude/commands/modify-fields.md`, `.claude/commands/add-email.md`
