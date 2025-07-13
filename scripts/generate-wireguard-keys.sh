#!/bin/bash

# WireGuard Key Generation Helper Script
# このスクリプトは WireGuard セットアップ用の鍵ペアを生成します

echo "WireGuard Key Generation Helper"
echo "================================"

# Check if WireGuard is installed
if ! command -v wg &> /dev/null; then
    echo "WireGuard is not installed. Please install it first:"
    echo "  Ubuntu/Debian: sudo apt install wireguard"
    echo "  macOS: brew install wireguard-tools"
    exit 1
fi

echo
echo "Generating keys for GitHub Actions client..."

# Generate client keys
CLIENT_PRIVATE_KEY=$(wg genkey)
CLIENT_PUBLIC_KEY=$(echo "$CLIENT_PRIVATE_KEY" | wg pubkey)

echo "Client Private Key (for WIREGUARD_CONFIG secret):"
echo "$CLIENT_PRIVATE_KEY"
echo

echo "Client Public Key (to add to server config):"
echo "$CLIENT_PUBLIC_KEY"
echo

echo "Generating keys for server (if needed)..."

# Generate server keys
SERVER_PRIVATE_KEY=$(wg genkey)
SERVER_PUBLIC_KEY=$(echo "$SERVER_PRIVATE_KEY" | wg pubkey)

echo "Server Private Key:"
echo "$SERVER_PRIVATE_KEY"
echo

echo "Server Public Key (for WIREGUARD_CONFIG secret):"
echo "$SERVER_PUBLIC_KEY"
echo

echo "================================"
echo "Next steps:"
echo "1. Use the Client Private Key in your WIREGUARD_CONFIG secret"
echo "2. Add the Client Public Key to your server's WireGuard configuration"
echo "3. Use the Server Public Key in your WIREGUARD_CONFIG secret"
echo "4. Configure your server with the Server Private Key"
echo
echo "Example WIREGUARD_CONFIG for GitHub secret:"
echo "[Interface]"
echo "PrivateKey = $CLIENT_PRIVATE_KEY"
echo "Address = 10.0.0.2/24"
echo "DNS = 8.8.8.8"
echo ""
echo "[Peer]"
echo "PublicKey = $SERVER_PUBLIC_KEY"
echo "Endpoint = YOUR_SERVER_IP:51820"
echo "AllowedIPs = 10.0.0.0/24"
echo "PersistentKeepalive = 25"