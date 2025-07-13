# playground

test4

## WireGuard VPN SSH Connection

GitHub Actions から自宅の WireGuard VPN 経由で SSH 接続を行うワークフローを実装しました。

詳細なセットアップ方法は [docs/wireguard-ssh-setup.md](docs/wireguard-ssh-setup.md) を参照してください。

### 主な機能

- GitHub Hosted Runner から WireGuard VPN を使用して自宅ネットワークに接続
- VPN 経由で自宅サーバーに SSH 接続
- 専用の SSH ユーザー（sudo 権限なし）を使用
- すべての設定項目を GitHub Secrets で安全に管理

### 使用方法

1. 必要な GitHub Secrets を設定
2. "WireGuard VPN SSH Connection" ワークフローを手動実行
3. 実行したいコマンドを入力して SSH 経由で実行
