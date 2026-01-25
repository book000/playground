# GitHub Copilot Instructions

## プロジェクト概要
- 目的: 開発・検証用の「遊び場」リポジトリ。
- 主な機能: GitHub Actions から WireGuard VPN を経由した SSH 接続の検証、スクリプトの管理。
- 対象ユーザー: 管理者、開発者。

## 共通ルール
- 会話は日本語で行う。
- PR とコミットは Conventional Commits に従う。
- 日本語と英数字の間には半角スペースを入れる。

## 技術スタック
- 言語: Bash (Shell Script)
- CI/CD: GitHub Actions
- ツール: WireGuard, SSH

## コーディング規約
- シェルスクリプトは `set -e` を使用し、エラー時に停止するようにする。
- 変数名はスネークケース、または定数の場合は大文字のスネークケースを使用する。

## 開発コマンド
```bash
# WireGuard 鍵の生成
./scripts/generate-wireguard-keys.sh

# テストの実行
./test/test-wireguard-config.sh
./test/test-workflow-config.sh
./test/demo-presharedkey.sh
```

## テスト方針
- `test/` ディレクトリ配下に Bash によるテストスクリプトを作成する。
- 重要な設定ファイルの形式やワークフローの整合性を検証する。

## セキュリティ / 機密情報
- WireGuard の秘密鍵や SSH の秘密鍵などの機密情報をリポジトリにコミットしない。
- 機密情報は GitHub Secrets で管理する。

## ドキュメント更新
- 重要な変更を加えた場合は `README.md` および `docs/wireguard-ssh-setup.md` を更新する。

## リポジトリ固有
- このリポジトリは検証用であるため、破壊的な変更を行う前には影響範囲を確認すること。
