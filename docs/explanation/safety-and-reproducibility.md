# Safety and reproducibility

Dotfiles deliberately change your environment. Conflict-safe linking and pinned
downloads reduce risk; they do not make every operation harmless or reversible.

## What the link helper protects

`scripts/lib/link.sh` creates/repairs managed links, refuses foreign destinations,
and backs conflicts up when adoption is explicit. It never replaces special
files. Ownership is determined by whether a link points into this checkout, not
by whether you intended that specific application to own it.

An adoption backup covers that destination only. It does not capture installed
tools, running sessions, caches, unrelated files, or secrets. Follow
[recovery instructions](../how-to/recover-configuration.md) instead of assuming
a Git revision change restores the whole machine.

## Installation and cleanup are not transactions

The installer prepares paths/tools before module preflight. It force-links the
global mise config without the shared adoption helper. A failed pull can be
followed by local application, and a later failure can leave earlier steps
applied. Individual module installs can access the network or update plugins.

Shared cleanup recursively deletes non-symlink module cache directories and
removes owned config links. Module clean targets can also remove fonts, helpers,
TPM, and—in OpenCode's non-profile cleanup—the CLI. Profile changes invoke these
targets after the new pass. Review removal effects before switching profiles.

Do not run `./install`, `make all`, upgrades, pruning, or real-home cleanup as
routine checks. Read-only state commands and isolated fixtures serve different
purposes from live deployment.

## Pinned downloads and their limits

The verified downloader checks HTTPS, response size, and SHA-256 before moving a
file into place. Non-mise artifact pins live with their module recipes:

| Artifact | Source of pin / verification |
| --- | --- |
| mise bootstrap | `scripts/bootstrap-mise.sh`; release archive checked against release checksums |
| `wt` | `git/Makefile`; version and SHA-256 |
| Antigen | `zsh/Makefile`; version/SHA-256, vendored startup source |
| `fzf-tmux` | `fzf/Makefile`; version and SHA-256 |
| TPM | `tmux/Makefile`; release tag and required commit |
| Fonts | `fonts/Makefile`; version/commit and archive/file SHA-256 |

Mise backend verification and lock metadata differ by tool. Exact CLI pins do
not pin external services, every editor tool, or all application plugins.
Rust's `stable` selector moves; module plugin managers can fetch updates. Bump
versions and matching digests together, review downloads and diffs, and report
which platforms were actually tested.

## Secrets are separate from configuration

Never commit private keys, passphrases, tokens, session data, or machine-local
permissions. The GPG helper copies only public-key armor; it does not upload
keys or turn signing on. SOPS and the vault have separate
[security boundaries](../../whalebyte/explanation.md).

Private identities belong outside the checkout. In particular, the current
psql defaults point `PGPASSFILE` into the linked config tree: override it to an
external private location before storing a database password. Encrypted files
still require backups and appropriate handling.

## Current implementation limitations

These are documented behavior or observed issues, not fixes made by this docs
reorganization:

- **Neovim restore:** the maintenance helper installs before restoring; lazy.nvim
  can rewrite the intended lockfile from installed revisions. Read the
  [restore caveat](../../nvim/how-to.md#restore-plugin-revisions).
- **Bat config path:** the shell points at `~/.bat.conf`, while installation
  links `bat/bat.conf` under XDG config. Use the documented
  [local override](../../bat/README.md#how-to-use-the-installed-preferences).
- **Portability:** legacy shell helpers can contain macOS clipboard commands,
  missing-tool assumptions, or destructive application operations. Inspect
  their module references; platform download resolution is not runtime proof.
- **Validation scope:** syntax/link checks do not prove live model quality,
  external service access, encryption recovery, or editor behavior.
