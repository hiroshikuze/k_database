# メール機能の追加手順

k_database にメール送信機能を追加・拡張する際の標準手順。

## 手順

1. **ビジネスロジックの実装**
   - `src/edit_sendmail_FEATURE_sub.pl` にメール送信ロジックを実装

2. **メール件名のエンコード**
   - 件名は必ず RFC2047 エンコードする
   ```perl
   require "./encodesubject_lib.pl";
   my $encoded_subject = &encode_subject($subject);
   ```

3. **sendmail の呼び出し**
   - sendmail バイナリのパスは `config.dat` に設定されている
   - `config.dat` の設定値を参照してパスを取得すること

## 注意事項

- 日本語件名は必ず `encodesubject_lib.pl` で RFC2047 BASE64 エンコードすること
- 本文の文字コードは EUC-JP で送信（`jcode.pl` で必要に応じて変換）
- sendmail のパスはハードコードせず `config.dat` の設定値を使用
- 既存の `edit_sendmail_naiyou_sub.pl` / `edit_sendmail_send_sub.pl` を参考にすること
