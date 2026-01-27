# Gemini CLI 作業方針

## 目的
Gemini CLI 向けのコンテキストと作業方針を定義します。

## 共通方針
- 共通の会話言語・コミット規約・空白ルールなどは [`AGENTS.md`](AGENTS.md) を参照してください。
- 本ファイルでは Gemini CLI 固有のルールのみを記載します。

## 出力スタイル
- 言語: 日本語
- トーン: 簡潔かつ直接的
- 形式: Markdown

## プロジェクト概要
- 目的: 開発・検証用の「遊び場」リポジトリ。
- 主な機能: GitHub Actions, WireGuard, SSH の検証。

## コーディング規約
- 言語: Bash
- コメント: 日本語
- エラーメッセージ: 英語

## 開発コマンド
```bash
# テストの実行
./test/test-wireguard-config.sh
./test/test-workflow-config.sh
./test/demo-presharedkey.sh
```

## 注意事項
- 認証情報のコミット禁止
- 既存のスタイルと構造を模倣する
- 変更後は必ずテストを実行する

## リポジトリ固有
- `README.md` の更新を忘れずに行うこと。
