# Copilot code review instructions

This is a scratch repository of GitHub Actions and shell experiments. It has no
build system, package manager, or linter, so reviews should focus on the shell
scripts and workflow YAML rather than application code.

## Review priorities

- **Secret handling (highest priority).** No credential — WireGuard private/preshared
  key, SSH private key, SSH host key, server IP/endpoint — may be hardcoded. These
  must come from GitHub Secrets. Flag any literal key material or real host address
  in workflows, scripts, or docs. Placeholders and `example.com`-style samples are fine.
- **Shell safety.** Scripts are `bash`. Flag unquoted variable expansions that
  could break on spaces, missing `set -e` in new scripts, and destructive commands
  (e.g. `rm -rf`) without a guarded path.
- **Workflow correctness.** Check that `secrets.*` references in workflows match
  the secrets documented in `docs/wireguard-ssh-setup.md`, and that temporary key
  files (e.g. `/tmp/id_rsa`) are cleaned up in an `always()` step.

## What not to flag

- The leftover scratch files (`hoge.md`, `date.txt`, `test.weather`) and the
  intentionally exhaustive `testing.yml` (which subscribes to every event) are
  deliberate experiments — do not suggest removing or "cleaning up" them.
- Do not ask for tests, CI, or a build config; this repo intentionally has none.
- Existing Japanese comments and documentation are intentional; do not request
  translation to English.
