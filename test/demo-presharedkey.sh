#!/bin/bash

# Demo script to show PresharedKey functionality
# This demonstrates the before and after configurations

echo "WireGuard PresharedKey Support Demo"
echo "==================================="
echo ""

echo "BEFORE: Configuration without PresharedKey support"
echo "---------------------------------------------------"
cat <<'EOF'
[Interface]
PrivateKey = CLIENT_PRIVATE_KEY
Address = 10.0.0.2/24
DNS = 8.8.8.8

[Peer]
PublicKey = SERVER_PUBLIC_KEY
Endpoint = server.example.com:51820
AllowedIPs = 10.0.0.0/24
PersistentKeepalive = 25
EOF

echo ""
echo "AFTER: Configuration with PresharedKey support (when WIREGUARD_PRESHARED_KEY is set)"
echo "-----------------------------------------------------------------------------------"
cat <<'EOF'
[Interface]
PrivateKey = CLIENT_PRIVATE_KEY
Address = 10.0.0.2/24
DNS = 8.8.8.8

[Peer]
PublicKey = SERVER_PUBLIC_KEY
PresharedKey = PRESHARED_KEY_FOR_EXTRA_SECURITY
Endpoint = server.example.com:51820
AllowedIPs = 10.0.0.0/24
PersistentKeepalive = 25
EOF

echo ""
echo "Key Benefits of PresharedKey:"
echo "• Protection against quantum computer attacks"
echo "• Additional layer of symmetric encryption"
echo "• Enhanced forward secrecy"
echo "• Optional - existing configurations continue to work"
echo ""

echo "New GitHub Secret to set (optional):"
echo "WIREGUARD_PRESHARED_KEY = <output from 'wg genpsk'>"
echo ""

echo "The same PresharedKey must be set on both client and server configurations."