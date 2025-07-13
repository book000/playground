# WireGuard VPN SSH Setup

このドキュメントでは、GitHub Actions から自宅の WireGuard VPN 経由で SSH 接続を行うためのセットアップ方法を説明します。

## 必要な GitHub Secrets

以下の secrets を GitHub リポジトリの Settings > Secrets and variables > Actions で設定してください：

### `WIREGUARD_CONFIG`
WireGuard クライアント設定ファイルの内容

```ini
[Interface]
PrivateKey = <クライアントの秘密鍵>
Address = <クライアントのVPNアドレス>/24
DNS = <DNSサーバー>

[Peer]
PublicKey = <サーバーの公開鍵>
Endpoint = <サーバーのパブリックIP>:<ポート>
AllowedIPs = <VPN内で許可するIPレンジ>
PersistentKeepalive = 25
```

### `HOME_SERVER_SSH_KEY`
SSH 接続用の秘密鍵（RSA または Ed25519）

### `HOME_SERVER_USER`
SSH 接続用のユーザー名（sudo 権限なし）

### `HOME_SERVER_HOST`
VPN 内での自宅サーバーの IP アドレス

## 自宅サーバーのセットアップ

### 1. SSH ユーザーの作成

```bash
# 専用ユーザーを作成（sudo 権限なし）
sudo useradd -m -s /bin/bash github-runner

# SSH ディレクトリを作成
sudo mkdir -p /home/github-runner/.ssh
sudo chmod 700 /home/github-runner/.ssh

# 公開鍵を追加
echo "<GitHub Actions用の公開鍵>" | sudo tee /home/github-runner/.ssh/authorized_keys
sudo chmod 600 /home/github-runner/.ssh/authorized_keys
sudo chown -R github-runner:github-runner /home/github-runner/.ssh
```

### 2. WireGuard サーバーの設定

WireGuard サーバーを設定し、GitHub Actions 用のピアを追加してください。

```ini
# /etc/wireguard/wg0.conf (サーバー側)
[Interface]
PrivateKey = <サーバーの秘密鍵>
Address = <サーバーのVPNアドレス>/24
ListenPort = <ポート番号>

[Peer]
# GitHub Actions クライアント
PublicKey = <クライアントの公開鍵>
AllowedIPs = <クライアントのVPNアドレス>/32
```

### 3. SSH設定の強化（オプション）

```bash
# /etc/ssh/sshd_config に追加
Match User github-runner
    AllowTcpForwarding no
    X11Forwarding no
    AllowAgentForwarding no
    PermitTunnel no
    ForceCommand echo "GitHub Actions SSH connection established"
```

## 使用方法

1. GitHub Actions の "WireGuard VPN SSH Connection" ワークフローを手動実行
2. 実行したいコマンドを入力（デフォルト: `hostname && whoami && pwd`）
3. ワークフローが VPN 接続を確立し、SSH 経由でコマンドを実行

## セキュリティ考慮事項

- SSH ユーザーには sudo 権限を付与しない
- WireGuard の設定で必要最小限の IP レンジのみ許可
- SSH 接続は VPN 経由のみ許可
- 秘密鍵とパスワードは GitHub Secrets で安全に管理
- 定期的な鍵のローテーション推奨

## トラブルシューティング

### VPN 接続が失敗する場合

1. WireGuard サーバーが起動していることを確認
2. ファイアウォールで WireGuard ポートが開放されていることを確認
3. `WIREGUARD_CONFIG` の設定が正しいことを確認

### SSH 接続が失敗する場合

1. SSH サーバーが起動していることを確認
2. SSH 鍵ペアが正しく設定されていることを確認
3. VPN 経由で SSH ポートにアクセスできることを確認