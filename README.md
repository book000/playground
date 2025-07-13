# WireGuard SSH Action

A GitHub Action that connects to a remote server via WireGuard VPN and executes SSH commands securely.

## Features

- Connect to remote networks through WireGuard VPN from GitHub hosted runners
- Execute SSH commands on remote servers through the VPN connection
- Secure configuration management using GitHub Secrets
- Automatic cleanup of temporary files and connections
- Support for optional PresharedKey for enhanced security

## Usage

### Basic Example

```yaml
name: Remote Server Access
on:
  workflow_dispatch:
    inputs:
      command:
        description: 'Command to execute'
        required: false
        default: 'hostname && whoami && pwd'

jobs:
  ssh-via-wireguard:
    runs-on: ubuntu-latest
    steps:
      - name: Connect and execute command
        uses: book000/playground@main
        with:
          command: ${{ github.event.inputs.command }}
          wireguard-private-key: ${{ secrets.WIREGUARD_PRIVATE_KEY }}
          wireguard-address: ${{ secrets.WIREGUARD_ADDRESS }}
          wireguard-peer-public-key: ${{ secrets.WIREGUARD_PEER_PUBLIC_KEY }}
          wireguard-endpoint: ${{ secrets.WIREGUARD_ENDPOINT }}
          wireguard-allowed-ips: ${{ secrets.WIREGUARD_ALLOWED_IPS }}
          ssh-private-key: ${{ secrets.SSH_PRIVATE_KEY }}
          ssh-user: ${{ secrets.SSH_USER }}
          ssh-hostname: ${{ secrets.SSH_HOSTNAME }}
          ssh-host-ip: ${{ secrets.SSH_HOST_IP }}
          ssh-host-key: ${{ secrets.SSH_HOST_KEY }}
```

### Advanced Example with PresharedKey

```yaml
- name: Connect with enhanced security
  uses: book000/playground@main
  with:
    command: 'sudo systemctl status nginx'
    wireguard-private-key: ${{ secrets.WIREGUARD_PRIVATE_KEY }}
    wireguard-address: ${{ secrets.WIREGUARD_ADDRESS }}
    wireguard-dns: '8.8.8.8'
    wireguard-peer-public-key: ${{ secrets.WIREGUARD_PEER_PUBLIC_KEY }}
    wireguard-preshared-key: ${{ secrets.WIREGUARD_PRESHARED_KEY }}
    wireguard-endpoint: ${{ secrets.WIREGUARD_ENDPOINT }}
    wireguard-allowed-ips: ${{ secrets.WIREGUARD_ALLOWED_IPS }}
    ssh-private-key: ${{ secrets.SSH_PRIVATE_KEY }}
    ssh-user: ${{ secrets.SSH_USER }}
    ssh-hostname: ${{ secrets.SSH_HOSTNAME }}
    ssh-host-ip: ${{ secrets.SSH_HOST_IP }}
    ssh-host-key: ${{ secrets.SSH_HOST_KEY }}
    ssh-port: '2222'
```

## Inputs

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `command` | Command to execute on remote server | No | `hostname && whoami && pwd` |
| `wireguard-private-key` | WireGuard client private key | Yes | |
| `wireguard-address` | WireGuard client VPN address (e.g., 10.0.0.2/24) | Yes | |
| `wireguard-dns` | DNS server address | No | `1.1.1.1` |
| `wireguard-peer-public-key` | WireGuard server public key | Yes | |
| `wireguard-preshared-key` | WireGuard preshared key (optional) | No | |
| `wireguard-endpoint` | WireGuard server endpoint (e.g., server.com:51820) | Yes | |
| `wireguard-allowed-ips` | Allowed IPs for WireGuard (e.g., 10.0.0.0/24) | Yes | |
| `ssh-private-key` | SSH private key for authentication | Yes | |
| `ssh-user` | SSH username | Yes | |
| `ssh-hostname` | SSH hostname alias for connection | Yes | |
| `ssh-host-ip` | SSH server IP address within VPN | Yes | |
| `ssh-host-key` | SSH server host key for verification | Yes | |
| `ssh-port` | SSH port number | No | `22` |

## Setup

Detailed setup instructions are available in [docs/wireguard-ssh-setup.md](docs/wireguard-ssh-setup.md).

### Quick Setup Summary

1. **Configure WireGuard Server**: Set up a WireGuard server and create a client configuration
2. **Create SSH User**: Create a dedicated user on your server for GitHub Actions access
3. **Generate Keys**: Use the provided script to generate WireGuard keys:
   ```bash
   ./scripts/generate-wireguard-keys.sh
   ```
4. **Set GitHub Secrets**: Configure all required secrets in your repository settings
5. **Get SSH Host Key**: Run `ssh-keyscan -t ed25519 <server-ip>` to get the host key

### Required GitHub Secrets

**WireGuard Configuration:**
- `WIREGUARD_PRIVATE_KEY`: Client private key
- `WIREGUARD_ADDRESS`: Client VPN address (e.g., `10.0.0.2/24`)
- `WIREGUARD_PEER_PUBLIC_KEY`: Server public key
- `WIREGUARD_ENDPOINT`: Server endpoint (e.g., `your-server.com:51820`)
- `WIREGUARD_ALLOWED_IPS`: Allowed IP ranges (e.g., `10.0.0.0/24`)
- `WIREGUARD_PRESHARED_KEY`: Preshared key (optional, for enhanced security)

**SSH Configuration:**
- `SSH_PRIVATE_KEY`: SSH private key
- `SSH_USER`: SSH username
- `SSH_HOSTNAME`: SSH hostname alias
- `SSH_HOST_IP`: Server IP within VPN
- `SSH_HOST_KEY`: SSH host key for verification

## Security Features

- **Isolated VPN Connection**: Creates a secure tunnel to your network
- **SSH Key Authentication**: Uses public key authentication only
- **Host Key Verification**: Prevents man-in-the-middle attacks
- **Automatic Cleanup**: Removes all temporary files and connections
- **Minimal Privileges**: Designed to work with non-sudo users
- **Optional PresharedKey**: Enhanced security against quantum attacks

## Example Use Cases

- Deploy applications to home servers
- Run maintenance scripts on remote infrastructure
- Monitor and manage home lab environments
- Execute backup and sync operations
- Perform system health checks

## License

This action is available under the MIT License.
