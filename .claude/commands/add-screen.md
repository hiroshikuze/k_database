# 新しい画面の追加手順

k_database に新しい CGI 画面を追加する際の標準手順。

## 手順

1. **HTML 出力ファイルの作成**
   - `src/html_SCREENNAME_sub.pl` を作成
   - 画面の HTML レンダリングロジックを実装

2. **ビジネスロジックファイルの作成**（必要な場合）
   - `src/SCREENNAME_sub.pl` を作成
   - データ処理・バリデーションロジックを実装

3. **`index.cgi` にステートハンドラーを追加**
   ```perl
   if ($sw eq "new_state_name") {
       require "./SCREENNAME_sub.pl";
       &SCREENNAME_subroutine();
   }
   ```

4. **画面へのリンクを追加**
   - 遷移元フォームやリンクから `$sw=new_state_name` を指定

## 注意事項

- ファイルは `src/` 直下にフラット配置（サブディレクトリ不可）
- フォームデータは `form_lib.pl` の `%form` ハッシュ経由でアクセス
- CSV I/O は必ず `file_access_lib.pl` を使用（直接ファイルアクセス禁止）
- 既存ファイルの命名規則に従うこと（`html_*_sub.pl` / `*_sub.pl`）
