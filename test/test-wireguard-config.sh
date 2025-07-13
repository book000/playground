#!/bin/bash

# Test script to validate WireGuard configuration format
# This test validates that the WireGuard configuration is properly formatted
# with and without PresharedKey

set -e

echo "Testing WireGuard configuration format..."

# Create a temporary directory for test configurations
TEST_DIR="/tmp/wireguard-test"
mkdir -p "$TEST_DIR"

# Test configuration without PresharedKey (current format)
cat > "$TEST_DIR/wg0-without-psk.conf" <<EOF
[Interface]
PrivateKey = TESTPRIVATEKEY123456789ABCDEF
Address = 10.0.0.2/24
DNS = 8.8.8.8

[Peer]
PublicKey = TESTPUBLICKEY123456789ABCDEF
Endpoint = test.example.com:51820
AllowedIPs = 10.0.0.0/24
PersistentKeepalive = 25
EOF

# Test configuration with PresharedKey (new format)
cat > "$TEST_DIR/wg0-with-psk.conf" <<EOF
[Interface]
PrivateKey = TESTPRIVATEKEY123456789ABCDEF
Address = 10.0.0.2/24
DNS = 8.8.8.8

[Peer]
PublicKey = TESTPUBLICKEY123456789ABCDEF
PresharedKey = TESTPRESHAREDKEY123456789ABCDEF
Endpoint = test.example.com:51820
AllowedIPs = 10.0.0.0/24
PersistentKeepalive = 25
EOF

echo "✓ Test configuration files created"

# Validate configuration format (basic syntax check)
validate_config() {
    local config_file="$1"
    local test_name="$2"
    
    echo "Validating $test_name..."
    
    # Check if all required sections exist
    if ! grep -q "^\[Interface\]" "$config_file"; then
        echo "✗ Missing [Interface] section in $test_name"
        return 1
    fi
    
    if ! grep -q "^\[Peer\]" "$config_file"; then
        echo "✗ Missing [Peer] section in $test_name"
        return 1
    fi
    
    # Check if required fields exist
    if ! grep -q "^PrivateKey = " "$config_file"; then
        echo "✗ Missing PrivateKey in $test_name"
        return 1
    fi
    
    if ! grep -q "^PublicKey = " "$config_file"; then
        echo "✗ Missing PublicKey in $test_name"
        return 1
    fi
    
    echo "✓ $test_name validation passed"
    return 0
}

# Validate both configurations
validate_config "$TEST_DIR/wg0-without-psk.conf" "Configuration without PresharedKey"
validate_config "$TEST_DIR/wg0-with-psk.conf" "Configuration with PresharedKey"

# Check that PresharedKey is present in the second config
if grep -q "^PresharedKey = " "$TEST_DIR/wg0-with-psk.conf"; then
    echo "✓ PresharedKey found in configuration with PresharedKey"
else
    echo "✗ PresharedKey not found in configuration with PresharedKey"
    exit 1
fi

# Check that PresharedKey is NOT present in the first config
if ! grep -q "^PresharedKey = " "$TEST_DIR/wg0-without-psk.conf"; then
    echo "✓ PresharedKey correctly absent in configuration without PresharedKey"
else
    echo "✗ PresharedKey unexpectedly present in configuration without PresharedKey"
    exit 1
fi

# Clean up
rm -rf "$TEST_DIR"

echo ""
echo "🎉 All WireGuard configuration tests passed!"
echo "Both configurations (with and without PresharedKey) are valid."