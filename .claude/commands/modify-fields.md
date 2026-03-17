# 顧客フィールドの変更手順

`kokyaku.csv` のフィールドを追加・削除・変更する際の標準手順。

## 手順

1. **`kokyaku.csv` スキーマの更新**
   - タブ区切りのカラムを追加・削除

2. **パース処理の更新**
   - `tab_cut_lib.pl` または呼び出し元コードで新しいカラムインデックスを参照するよう修正

3. **表示・編集ファイルの更新**
   - `html_syousai0_sub.pl`, `html_syousai1_sub.pl`, `html_syousai2_sub.pl` — 詳細表示
   - `edit_check_sub.pl`, `edit_save_sub.pl` — 編集・保存処理
   - `edit_rireki_sub.pl` — 履歴処理

4. **ドロップダウンの更新**（フィールドがセレクト形式の場合）
   - `options_lib.pl` の対応箇所を修正

## 注意事項

- `@cut_end` 配列のインデックスは 0 始まり
- フィールドを追加した場合は既存データとの互換性に注意（既存行の末尾に追加が安全）
- `downdata.cgi` のエクスポート処理も忘れずに確認すること
