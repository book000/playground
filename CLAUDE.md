# CLAUDE.md

## Overview

`playground` is a personal scratch repository for experimenting with GitHub
Actions and shell scripting. Most of its contents are throwaway experiments;
treat files here as disposable unless they are clearly part of a maintained
feature. There is no application to build and no package manager.

The one non-trivial feature is a **WireGuard VPN SSH** workflow that connects a
GitHub-hosted runner to a home server over WireGuard and runs a command via SSH.

## Layout

- `.github/workflows/` — experimental workflows, each independent:
  - `wireguard-ssh.yml` — the WireGuard VPN SSH feature (manual dispatch).
  - `testing.yml` — dumps every GitHub Actions context for inspection.
  - `rdp-chrome.yml` — spins up Chrome + SSH-over-ngrok (experiment).
  - `comment-format.yml` — appends to `date.txt` on a PR comment trigger.
  - `copilot-enforcer.yml` — runs `book000/copilot-review-enforcer`.
- `scripts/generate-wireguard-keys.sh` — WireGuard key-pair generation helper.
- `test/*.sh` — standalone shell scripts that validate the WireGuard config
  format; not wired into CI.
- `docs/wireguard-ssh-setup.md` — setup guide for the WireGuard SSH workflow.
- `hoge.md`, `date.txt`, `test.weather` — leftover experiment scratch files.

## Commands

There is no build or lint tooling. The shell scripts are the only runnable code:

- `bash test/test-wireguard-config.sh` — validate the WireGuard config format.
- `bash test/test-workflow-config.sh` — validate the workflow's config generation.
- `bash scripts/generate-wireguard-keys.sh` — generate WireGuard keys (needs `wg`).

## Conventions

- Shell scripts are `bash` with `set -e`; keep new scripts consistent with that.
- Existing docs and script comments are written in Japanese; match the surrounding
  language when editing a given file.

## Security

- All WireGuard and SSH credentials come from **GitHub Secrets**. Never hardcode
  private keys, preshared keys, host keys, or server addresses in workflows,
  scripts, or docs — use placeholders/examples only.
- The SSH user on the home server must have no sudo rights; SSH is reachable only
  through the VPN. Preserve these constraints when touching `wireguard-ssh.yml`.

## Documentation

- Changes to `wireguard-ssh.yml` that add, rename, or remove a secret must be
  reflected in `docs/wireguard-ssh-setup.md` (and the README's summary).
