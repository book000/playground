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

echo "Generating PresharedKey for enhanced security..."

# Generate PresharedKey
PRESHARED_KEY=$(wg genpsk)

echo "PresharedKey (for WIREGUARD_PRESHARED_KEY secret, optional):"
echo "$PRESHARED_KEY"
echo

echo "================================"
echo "Next steps:"
echo "1. Use the Client Private Key in your WIREGUARD_PRIVATE_KEY secret"
echo "2. Add the Client Public Key to your server's WireGuard configuration"
echo "3. Use the Server Public Key in your WIREGUARD_PEER_PUBLIC_KEY secret"
echo "4. (Optional) Use the PresharedKey in your WIREGUARD_PRESHARED_KEY secret for enhanced security"
echo "5. Configure your server with the Server Private Key"
echo "6. (Optional) Add the same PresharedKey to your server's peer configuration"
echo
echo "Example GitHub secrets configuration:"
echo "WIREGUARD_PRIVATE_KEY = $CLIENT_PRIVATE_KEY"
echo "WIREGUARD_PEER_PUBLIC_KEY = $SERVER_PUBLIC_KEY"
echo "WIREGUARD_PRESHARED_KEY = $PRESHARED_KEY"
echo ""
echo "Example server config for your client peer:"
echo "[Peer]"
echo "PublicKey = $CLIENT_PUBLIC_KEY"
echo "PresharedKey = $PRESHARED_KEY"
echo "AllowedIPs = 10.0.0.2/32"