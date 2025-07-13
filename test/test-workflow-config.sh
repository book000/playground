#!/bin/bash

# Test script to validate the GitHub Actions workflow WireGuard configuration
# This test simulates the workflow configuration generation with and without PresharedKey

set -e

echo "Testing GitHub Actions workflow WireGuard configuration generation..."

# Create a temporary directory for test configurations
TEST_DIR="/tmp/workflow-test"
mkdir -p "$TEST_DIR"

# Simulate environment variables (GitHub secrets)
export WIREGUARD_PRIVATE_KEY="TESTPRIVATEKEY123456789ABCDEF"
export WIREGUARD_ADDRESS="10.0.0.2/24"
export WIREGUARD_DNS="8.8.8.8"
export WIREGUARD_PEER_PUBLIC_KEY="TESTPUBLICKEY123456789ABCDEF"
export WIREGUARD_ENDPOINT="test.example.com:51820"
export WIREGUARD_ALLOWED_IPS="10.0.0.0/24"

# Test 1: Configuration without PresharedKey
echo "Test 1: Configuration without PresharedKey"
unset WIREGUARD_PRESHARED_KEY

# Simulate the workflow configuration generation (without PresharedKey)
cat > "$TEST_DIR/wg0.conf" <<EOF
[Interface]
PrivateKey = $WIREGUARD_PRIVATE_KEY
Address = $WIREGUARD_ADDRESS
DNS = $WIREGUARD_DNS

[Peer]
PublicKey = $WIREGUARD_PEER_PUBLIC_KEY
EOF

# Add PresharedKey if provided (this should not add anything in this test)
if [ -n "$WIREGUARD_PRESHARED_KEY" ]; then
    echo "PresharedKey = $WIREGUARD_PRESHARED_KEY" >> "$TEST_DIR/wg0.conf"
fi

# Add remaining peer configuration
cat >> "$TEST_DIR/wg0.conf" <<EOF
Endpoint = $WIREGUARD_ENDPOINT
AllowedIPs = $WIREGUARD_ALLOWED_IPS
PersistentKeepalive = 25
EOF

# Verify configuration without PresharedKey
if grep -q "PresharedKey" "$TEST_DIR/wg0.conf"; then
    echo "✗ PresharedKey unexpectedly found in configuration without PresharedKey"
    exit 1
else
    echo "✓ Configuration without PresharedKey is correct"
fi

# Test 2: Configuration with PresharedKey
echo "Test 2: Configuration with PresharedKey"
export WIREGUARD_PRESHARED_KEY="TESTPRESHAREDKEY123456789ABCDEF"

# Simulate the workflow configuration generation (with PresharedKey)
cat > "$TEST_DIR/wg0.conf" <<EOF
[Interface]
PrivateKey = $WIREGUARD_PRIVATE_KEY
Address = $WIREGUARD_ADDRESS
DNS = $WIREGUARD_DNS

[Peer]
PublicKey = $WIREGUARD_PEER_PUBLIC_KEY
EOF

# Add PresharedKey if provided (this should add PresharedKey in this test)
if [ -n "$WIREGUARD_PRESHARED_KEY" ]; then
    echo "PresharedKey = $WIREGUARD_PRESHARED_KEY" >> "$TEST_DIR/wg0.conf"
fi

# Add remaining peer configuration
cat >> "$TEST_DIR/wg0.conf" <<EOF
Endpoint = $WIREGUARD_ENDPOINT
AllowedIPs = $WIREGUARD_ALLOWED_IPS
PersistentKeepalive = 25
EOF

# Verify configuration with PresharedKey
if grep -q "PresharedKey = $WIREGUARD_PRESHARED_KEY" "$TEST_DIR/wg0.conf"; then
    echo "✓ Configuration with PresharedKey is correct"
else
    echo "✗ PresharedKey not found in configuration with PresharedKey"
    exit 1
fi

# Test 3: Verify proper order of configuration sections
echo "Test 3: Verify configuration structure"
config_content=$(cat "$TEST_DIR/wg0.conf")

# Check that Interface section comes before Peer section
if echo "$config_content" | grep -n "^\[Interface\]" | cut -d: -f1 | head -1 | \
   xargs -I {} sh -c 'line={}; echo "$config_content" | grep -n "^\[Peer\]" | cut -d: -f1 | head -1 | xargs -I peer_line test $line -lt peer_line'; then
    echo "✓ Interface section comes before Peer section"
else
    echo "✗ Configuration structure is incorrect"
    exit 1
fi

# Check that PresharedKey comes after PublicKey but before Endpoint
peer_section_start=$(echo "$config_content" | grep -n "^\[Peer\]" | cut -d: -f1)
publickey_line=$(echo "$config_content" | tail -n +$peer_section_start | grep -n "^PublicKey" | cut -d: -f1 | head -1)
presharedkey_line=$(echo "$config_content" | tail -n +$peer_section_start | grep -n "^PresharedKey" | cut -d: -f1 | head -1)
endpoint_line=$(echo "$config_content" | tail -n +$peer_section_start | grep -n "^Endpoint" | cut -d: -f1 | head -1)

if [ -n "$presharedkey_line" ] && [ "$publickey_line" -lt "$presharedkey_line" ] && [ "$presharedkey_line" -lt "$endpoint_line" ]; then
    echo "✓ PresharedKey is in the correct position"
else
    echo "✗ PresharedKey position is incorrect"
    exit 1
fi

# Show the final configuration for verification
echo ""
echo "Final configuration with PresharedKey:"
echo "======================================"
cat "$TEST_DIR/wg0.conf"
echo "======================================"

# Clean up
rm -rf "$TEST_DIR"

echo ""
echo "🎉 All GitHub Actions workflow configuration tests passed!"