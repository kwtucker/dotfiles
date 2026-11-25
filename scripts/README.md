# Deployment and state helpers

Bash helpers for offline inspection, link deployment, verified downloads, GPG
configuration, and applied-state stamps. They target Bash 3.2 on macOS and modern
Bash on Linux; read-only state tooling avoids jq/Python dependencies.

## How-to inspect or maintain the system

- [Update an installation](../docs/how-to/update-dotfiles.md)
- [Recover conflicting configuration](../docs/how-to/recover-configuration.md)
- [Add a module safely](../docs/how-to/add-module.md)

For read-only inspection from the checkout root:

```sh
scripts/state check-links --preflight
scripts/state status --json
scripts/state doctor
```

`doctor --online` additionally queries remote information. Do not run installers
or cleanup to check whether documentation examples are accurate. For shell
changes, `make lint` checks syntax/ShellCheck/formatting; `make fmt` rewrites
files. Keep fixtures in temporary directories outside this checkout and remove
them afterward; no persistent test suite belongs here.

## Reference

| File | Contract / writes | Exit behavior |
| --- | --- | --- |
| `state` | Read-only Make/Git/filesystem evidence; offline unless requested | `check-links`/`doctor`: 0 success, 1 failure, 2 usage; status normally 0, drift 1 with `--exit-code` |
| `prune-links` | Preview stale links; `--force` delegates owned unlinking | 0 success, 1 failure, 2 usage |
| `lib/common.sh` | Shared environment/metadata helpers; no intended writes | Sourced |
| `lib/links.sh` | Expected links and verification; no writes | Sourced |
| `lib/link.sh` | Symlinks, missing parents, adoption backups, owned unlinking | 0 success, 1 conflict, 2 usage/fatal |
| `lib/stamp.sh` | Verify/write `$XDG_STATE_HOME/dotfiles/last-applied` atomically | Verification/write return success/failure |
| `lib/tools.sh` | Pure profile comparison/local declaration parsing | Sourced; does not uninstall tools |
| `lib/gpg.sh` | Generate ignored agent config; delegate home link changes | Install/clean; missing shim is a reported skip, conflicts fail |
| `lib/fetch.sh`, `fetch` | HTTPS download, size/digest checks, temporary file and rename | 0 success, 1 download/verification failure, 2 usage/dependency errors |
| `bootstrap-mise.sh` | Verify release archive/checksums and install user-local mise | 0 installed/skipped; failures nonzero |

State CLI forms:

```text
scripts/state check-links [--quiet] [--preflight] [--strict]
scripts/state status [--exit-code] [--json]
scripts/state doctor [--online] [--json] [--verbose]
```

Verified download form:

```text
scripts/fetch HTTPS_URL DESTINATION SHA256 [MODE]
```

Adoption stores HOME-relative paths beneath the backup run directory and records
`adopt<TAB>destination<TAB>backup` in `manifest.tsv`. Source files/directories
must exist; special destination files are refused. See the
[environment reference](../docs/reference/environment.md) for path/backup knobs.

## Explanation: inspection is not application

`install` orchestrates tools, module links, cleanup, and stamps. The state helper
only reports evidence. Expected-link preflight is useful but does not cover
every write, missing future generated config, or application runtime behavior.
The global mise force-link and module-specific download/cache operations are
outside the shared link helper's adoption contract.

GPG output is generated locally from a tracked template so different computers
resolve their own Pinentry paths. Keys stay in the real GPG home; linking the
entire mutable home would expose private state and undermine ownership-safe
cleanup. See the [Git reference](../git/reference.md#gpg-paths).

Stamps record successful application, not whole-home snapshots. Verified
downloads establish artifact integrity against the recorded digest, not the
safety of arbitrary downloaded code. Read the
[safety explanation](../docs/explanation/safety-and-reproducibility.md) for
current boundaries and implementation limitations.
