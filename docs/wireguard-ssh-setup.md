# WireGuard VPN SSH Setup

このドキュメントでは、GitHub Actions から自宅の WireGuard VPN 経由で SSH 接続を行うためのセットアップ方法を説明します。

## 必要な GitHub Secrets

以下の secrets を GitHub リポジトリの Settings > Secrets and variables > Actions で設定してください：

### WireGuard 設定関連

#### `WIREGUARD_PRIVATE_KEY`
WireGuard クライアントの秘密鍵

#### `WIREGUARD_ADDRESS`
クライアントの VPN アドレス（例: `10.0.0.2/24`）

#### `WIREGUARD_DNS`
DNS サーバーアドレス（例: `1.1.1.1`）

#### `WIREGUARD_PEER_PUBLIC_KEY`
WireGuard サーバーの公開鍵

#### `WIREGUARD_PRESHARED_KEY` (オプション)
事前共有鍵（PresharedKey）
※ セキュリティ強化のためのオプション設定。量子コンピューター攻撃に対する追加の保護を提供

#### `WIREGUARD_ENDPOINT`
サーバーのパブリック IP とポート（例: `your-server.com:51820`）

#### `WIREGUARD_ALLOWED_IPS`
VPN 内で許可する IP レンジ（例: `10.0.0.0/24`）

### SSH 接続関連

#### `HOME_SERVER_SSH_KEY`
SSH 接続用の秘密鍵（RSA または Ed25519）
※ パスワードなしの公開鍵認証で接続されます

#### `HOME_SERVER_USER`
SSH 接続用のユーザー名（sudo 権限なし）

#### `HOME_SERVER_HOST`
VPN 内での自宅サーバーの IP アドレス

#### `HOME_SERVER_HOST_KEY`
SSH ホストキー（セキュリティのため必須）
※ サーバーで `ssh-keyscan -t rsa,ed25519 <サーバーのIP>` で取得可能

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
PresharedKey = <事前共有鍵（オプション）>
AllowedIPs = <クライアントのVPNアドレス>/32
```

#### PresharedKey について

PresharedKey（事前共有鍵）は WireGuard のオプション機能で、以下のメリットがあります：

- **量子コンピューター攻撃への耐性**: 将来の量子コンピューターによる攻撃から保護
- **追加の暗号化層**: 既存の公開鍵暗号化に加えて対称鍵暗号化を使用
- **Forward Secrecy の強化**: より強固な前方秘匿性を提供

PresharedKey を生成するには：
```bash
wg genpsk
```

または、提供されているスクリプトを使用：
```bash
./scripts/generate-wireguard-keys.sh
```

### 3. SSH ホストキーの取得

セキュリティのため、SSH 接続前にホストキーを取得して GitHub Secrets に保存します：

```bash
# サーバーのホストキーを取得
ssh-keyscan -t rsa,ed25519 <サーバーのVPNアドレス>
```

出力例：
```
10.0.0.1 ssh-rsa AAAAB3NzaC1yc2EAAAA...
10.0.0.1 ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI...
```

このうち1行（推奨は ed25519）を `HOME_SERVER_HOST_KEY` secret として設定してください。

### 4. GitHub Secrets の設定例

WireGuard の設定を各項目ごとに個別の secrets として設定：

- `WIREGUARD_PRIVATE_KEY`: `aBcD1234...` (クライアントの秘密鍵)
- `WIREGUARD_ADDRESS`: `10.0.0.2/24`
- `WIREGUARD_DNS`: `1.1.1.1`
- `WIREGUARD_PEER_PUBLIC_KEY`: `xYz9876...` (サーバーの公開鍵)
- `WIREGUARD_PRESHARED_KEY`: `pQr3456...` (事前共有鍵、オプション)
- `WIREGUARD_ENDPOINT`: `your-server.com:51820`
- `WIREGUARD_ALLOWED_IPS`: `10.0.0.0/24`
- `HOME_SERVER_SSH_KEY`: `-----BEGIN OPENSSH PRIVATE KEY-----...` (SSH秘密鍵)
- `HOME_SERVER_USER`: `github-runner`
- `HOME_SERVER_HOST`: `10.0.0.1`
- `HOME_SERVER_HOST_KEY`: `ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI...` (ホストキー)

### 4. SSH設定の強化（オプション）

github-runner ユーザー専用のセキュリティ設定を追加することで、攻撃面を最小化できます：

```bash
# /etc/ssh/sshd_config に追加
Match User github-runner
    AllowTcpForwarding no
    X11Forwarding no
    AllowAgentForwarding no
    PermitTunnel no
    # ForceCommandは設定しない（コマンド実行を許可するため）
```

#### 各設定項目の説明：

- **AllowTcpForwarding no**: TCPポートフォワーディングを無効化
  - 攻撃者がサーバーを踏み台にして他のサービスにアクセスすることを防止
  - ネットワーク内の他のサービスへの不正アクセスリスクを軽減

- **X11Forwarding no**: X11転送を無効化
  - GUI アプリケーションの転送を禁止し、デスクトップ環境への不正アクセスを防止
  - X11 プロトコルの脆弱性を回避

- **AllowAgentForwarding no**: SSH エージェント転送を無効化
  - SSH 秘密鍵の転送を禁止し、鍵の漏洩リスクを軽減
  - 多段SSH接続での認証情報の伝播を防止

- **PermitTunnel no**: SSH トンネリングを無効化
  - VPN のような機能の使用を禁止し、ネットワーク境界の迂回を防止
  - 管理されていないネットワーク経路の作成を阻止

これらの設定により、github-runner ユーザーは最小限の権限でコマンド実行のみが可能となり、システム全体のセキュリティが向上します。

## 使用方法

1. GitHub Actions の "WireGuard VPN SSH Connection" ワークフローを手動実行
2. 実行したいコマンドを入力（デフォルト: `hostname && whoami && pwd`）
3. ワークフローが VPN 接続を確立し、SSH 経由でコマンドを実行

## セキュリティ考慮事項

- SSH ユーザーには sudo 権限を付与しない
- WireGuard の設定で必要最小限の IP レンジのみ許可
- SSH 接続は VPN 経由のみ許可
- SSH ホストキー検証を有効にして中間者攻撃を防止
- 秘密鍵とパスワードは GitHub Secrets で安全に管理
- 定期的な鍵のローテーション推奨

## トラブルシューティング

### VPN 接続が失敗する場合

1. WireGuard サーバーが起動していることを確認
2. ファイアウォールで WireGuard ポートが開放されていることを確認
3. 各 WireGuard secrets の設定が正しいことを確認

### SSH 接続が失敗する場合

1. SSH サーバーが起動していることを確認
2. SSH 鍵ペアが正しく設定されていることを確認（パスワードなしの公開鍵認証）
3. VPN 経由で SSH ポートにアクセスできることを確認
4. SSH ユーザーが正しく作成され、公開鍵が authorized_keys に追加されていることを確認
5. ホストキーが正しく設定されていることを確認（`ssh-keyscan` で再取得して比較）

### ホストキー検証エラーが発生する場合

```
Host key verification failed
```

このエラーが発生した場合：
1. サーバーのホストキーが変更されていないか確認
2. `ssh-keyscan -t rsa,ed25519 <サーバーIP>` で最新のホストキーを取得
3. `HOME_SERVER_HOST_KEY` secret を新しいホストキーに更新