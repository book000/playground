# Testing WireGuard SSH Action with nektos/act

This document explains how to test the WireGuard SSH GitHub Action locally using nektos/act.

## Overview

We have created two test workflows that can be run with nektos/act:

1. **Act Integration Test** (`.github/workflows/act-integration-test.yml`) - A simplified test that validates action behavior without requiring actual VPN connectivity
2. **Integration Test WireGuard SSH Action** (`.github/workflows/integration-test-wireguard-ssh.yml`) - A comprehensive test with real Docker containers (requires special setup for act)

## Installation

First, install nektos/act:

```bash
curl https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash
```

## Running Tests

### Option 1: Simple Act-Compatible Test (Recommended)

This test validates action functionality without requiring Docker-in-Docker:

```bash
act -W .github/workflows/act-integration-test.yml
```

This test validates:
- ✅ Input validation works correctly
- ✅ WireGuard configuration generation works
- ✅ SSH key format validation works
- ✅ Action fails gracefully with invalid network endpoints

### Option 2: Full Integration Test (Advanced)

The full integration test requires Docker-in-Docker capabilities. With standard act setup, this will fail because act itself runs in Docker and cannot easily spawn additional containers.

To run this test with act, you would need:

```bash
# This will fail with standard act setup due to Docker-in-Docker limitations
act -W .github/workflows/integration-test-wireguard-ssh.yml
```

For the full integration test to work with act, you would need to run act with Docker socket mounting and privileged mode, which has security implications and is not recommended for general testing.

## Test Results

### Act Integration Test Results

When you run the act-compatible test, you should see output like:

```
🎉 Act-compatible integration tests completed!

✅ Input validation works correctly
✅ WireGuard configuration generation works
✅ SSH key format validation works
✅ Action fails gracefully with invalid network endpoints

Note: This test validates action behavior without requiring
actual VPN connectivity, making it suitable for nektos/act testing.
```

### Recommendations

1. **For local development and validation**: Use the act-compatible test (`.github/workflows/act-integration-test.yml`)
2. **For full end-to-end testing**: Use GitHub Actions with the full integration test (`.github/workflows/integration-test-wireguard-ssh.yml`)

The act-compatible test provides sufficient validation for most development needs while being easy to run locally without complex Docker setup requirements.

## Troubleshooting

If you encounter issues:

1. **Docker permission errors**: Make sure your user is in the `docker` group
2. **Act not found**: Ensure `/usr/local/bin` is in your PATH after installation
3. **Memory issues**: Use act with `--pull=false` flag to skip image pulling if you have limited bandwidth

## Action Validation Covered

The act-compatible test covers these critical aspects:
- Input parameter validation
- Configuration file generation
- Error handling for invalid network endpoints
- SSH key format validation
- WireGuard configuration format validation

This ensures the action will behave correctly when deployed to GitHub Actions while being testable in local development environments.