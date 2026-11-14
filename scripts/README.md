# scripts

Shell helpers behind `make doctor`, `make status`, verified downloads, and
module linking. They target **bash 3.2** (macOS) and modern bash on Linux, and
must work without `jq`, `python`, or any non-POSIX tool beyond `git`, `curl`,
`awk`, and standard file utilities.

## Contract map

| File | Kind | Reads | Writes | Exit codes |
| --- | --- | --- | --- | --- |
| `state` | executable | git, Make metadata, XDG/mise paths, links, artifacts | **nothing** | `check-links` 0/1/2; `status` 0 (1 with `--exit-code`); `doctor` 0/1/2 |
| `prune-links` | executable | expected-link model, filesystem | stale symlinks (only with `--force`) | 0 clean/pruned, 1 failed, 2 usage |
| `lib/common.sh` | sourced | environment | nothing | n/a |
| `lib/links.sh` | sourced | expected-link model, filesystem | nothing | n/a |
| `lib/link.sh` | executable | source paths, destinations | symlinks, parent directories, adoption backups, stale owned links | 0 ok, 1 conflict, 2 usage/fatal |
| `lib/stamp.sh` | sourced | git, XDG paths, local overrides | `${XDG_STATE_HOME}/dotfiles/last-applied` (atomic) | 0 verified/applied, 1 stale/failed |
| `lib/fetch.sh` | sourced | HTTPS URL + SHA-256 | destination + temporary file | 0 ok, 1 download/verify failure, 2 usage |
| `fetch` | executable | same as `lib/fetch.sh` | same as `lib/fetch.sh` | 0 ok, 1 failure, 2 usage |
| `bootstrap-mise.sh` | executable | pinned release + `SHASUMS256.txt` | `$HOME/.local/bin/mise` (755), temp dir | 0 installed/skipped, 1 failure, 2 usage |

The top-level `install` is the orchestrator: it pulls the checkout, installs
mise/tools, runs the link preflight, invokes the module Makefiles, and writes the
stamp only after a successful pass. In Docker, Codespaces, and devcontainers it
exports `DOTFILES_SKIP_FONTS=1` before the module pass; the `fonts` module leaves
a marker in the state directory instead of downloading fonts.

## Read-only tooling

`scripts/state` is the only entrypoint shared by `make status` and `make doctor`:

```sh
scripts/state check-links [--quiet] [--preflight] [--strict]
scripts/state status [--exit-code] [--json]
scripts/state doctor [--online] [--json] [--verbose]
```

- It never creates directories, changes links, or writes the stamp.
- It is offline by default; only `doctor --online` touches the network.
- `check-links --preflight` reports just the destinations a default install would
  refuse, so `./install` can abort before any module mutates the home directory.
- `doctor` prints a remediation command for every warning and failure.

## Write boundaries

Only these files may change the machine:

- `lib/link.sh` — creates/repairs symlinks and, with `DOTFILES_ADOPT=1`, moves
  conflicting paths under `${XDG_STATE_HOME}/dotfiles/backups/<timestamp>/` and
  appends to `manifest.tsv`. Its `prune_link` command removes a symlink only
  after confirming its target still resolves inside the checkout. It never
  deletes a real destination.
- `prune-links` — lists stale links into this checkout by default; `--force`
  asks `lib/link.sh` to unlink each one. It never touches foreign links or real
  files.
- `lib/stamp.sh` — `stamp_write` records the applied inputs after a successful
  module pass. It is atomic; a failed or interrupted run leaves no fresh stamp.
- `lib/fetch.sh` / `fetch` — download to a temporary file, verify size and
  SHA-256, then rename into place. Partial or mismatched files are removed.
- `bootstrap-mise.sh` — verifies the release archive against the release's
  checksum file before writing the binary.

`lib/common.sh` and `lib/links.sh` are read-only helpers sourced by the above.

## Environment knobs

| Variable | Used by | Meaning |
| --- | --- | --- |
| `DOTFILES_ROOT` | most scripts | Checkout root; defaults to the repository containing the script |
| `XDG_CONFIG_HOME`, `XDG_CACHE_HOME`, `XDG_DATA_HOME`, `XDG_STATE_HOME` | most scripts | Default to `$HOME/.config`, `$HOME/.cache`, `$HOME/.local/share`, `$HOME/.local/state` |
| `DOTFILES_ADOPT` | `lib/link.sh` | `1` adopts conflicting destinations with a backup |
| `DOTFILES_BACKUP_ROOT`, `DOTFILES_BACKUP_ID` | `lib/link.sh` | Override the backup parent or run directory name |
| `DOTFILES_SKIP_FONTS` | `install`, `fonts` | `1` skips the font download and records `${XDG_STATE_HOME}/dotfiles/fonts-skipped`; `0` overrides container detection |
| `FETCH_MAX_BYTES` | `lib/fetch.sh` | Reject downloads larger than this (default 256 MiB) |
| `MISE_BOOTSTRAP_VERSION`, `MISE_BOOTSTRAP_DEST` | `bootstrap-mise.sh` | Override the pinned mise release or install path |
| `FORCE` | `install` | `1` bypasses the applied-state fast path |

## Reviewing shell changes

Run the same checks CI uses:

```sh
make lint   # bash -n, shellcheck -x, shfmt -d
make fmt    # rewrite with shfmt (-i 2 -ci)
```

Conventions:

- Quote expansions and pass paths explicitly; no `eval` when indirect expansion
  or a `case` will do.
- Keep writes inside the boundaries above.
- Keep functions single-purpose and use `local`/prefixed globals deliberately.
- Add `# shellcheck source=...` next to `.` includes so ShellCheck follows them.
- New persistent tests are not allowed in this repository; validation fixtures
  belong under `/tmp/opencode` and must be removed.
- Bump a download pin and its SHA-256 together; see the “Pinned downloads”
  section of the root `README.md`.
