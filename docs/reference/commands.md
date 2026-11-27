# Command reference

Run Make commands from the checkout root unless a module directory is shown.
Read-only means no intended filesystem changes; offline commands do not make
network requests. A successful exit does not establish interactive integration
quality. GNU Make generally reports recipe failure as exit status `2`.

## Inspection

| Command | Effect |
| --- | --- |
| `make profile.list` / `make profile.show` | Show profiles or active selection; offline |
| `make tools.list` | Show resolved active tools; offline |
| `make tools.check` | Check catalog/ownership consistency; offline |
| `make status` | Show repository, applied state, links, and tools; offline by default |
| `make doctor` | Diagnose state with remediation; offline by default |
| `make doctor ARGS=--online` | Also check update/remote information; network |
| `make status ARGS=--json` | Emit machine-readable state |
| `make status ARGS=--exit-code` | Fail when state has drifted |
| `scripts/state check-links` | Verify expected links; offline |
| `scripts/state check-links --preflight` | Report conflicting modeled destinations |
| `scripts/state check-links --strict` | Also fail on discovered orphan links |
| `make prune.links` | Preview stale links; dry run unless overriding arguments |
| `make outdated` | Query within-range versions and bump candidates; network/cache access, no intentional install |
| `make help` | Display targets and descriptions |

`scripts/state doctor` and `check-links` use `0` for success, `1` for
failure/drift as applicable, and `2` for usage errors. `status` normally exits
`0`; `--exit-code` makes drift return `1`. Doctor warnings alone do not fail.
See [script contracts](../../scripts/README.md#reference).

## Applying and selecting

| Command | Writes / side effects |
| --- | --- |
| `./install`, `make install`, `make update` | Pull, tool installation, module application, profile cleanup, pruning, state stamps, possible tmux recycling |
| `FORCE=1 ./install` | Same effects, but bypasses module fast path |
| `make all` | Run selected module installs; no profile-switch cleanup or applied-state stamp; modules can have extra effects |
| `make MODULE` | Install one module and its root-target dependencies/completions |
| `make tools.install` | Install active tools and regenerate mise shims |
| `make profile.set PROFILE=NAME` | Write ignored `profile.local`; does not apply |
| `make profile.clear` | Remove `profile.local`; does not apply |

## Updating and removing

These commands change state; review affected modules first.

| Command | Writes / side effects |
| --- | --- |
| `make upgrade.tools` | Upgrade within selectors, refresh lockfile/completions, prune |
| `make upgrade.bump` | Rewrite eligible `mise.toml` pins, re-lock four platforms, refresh completions, prune, validate; excludes `http:opencode` |
| `make MODULE.upgrade` | Module-specific updates if an upgrade target exists; otherwise skip |
| `make upgrade.plugins` | Module upgrade targets; may access network and change plugin/config state |
| `make upgrade.all` | Tool and module updates |
| `make prune.tools` | Remove superseded mise versions and regenerate shims |
| `make prune.links.apply` | Remove stale discovered links that still point into this checkout |
| `make MODULE.clean` | Module-specific removal; consult its README |
| `make clean.all` | Cleanup for the selected modules; not whole-machine uninstall |

`make upgrade.bump` is opt-in and rewrites `mise.toml`; `make upgrade.tools` and
`make upgrade.all` stay within the configured selectors. It aborts before
rewriting pins when mise cannot see a GitHub token (normally exported from `gh`
by `git/env.zsh`). `http:opencode` is excluded because its four platform digests
must be replaced along with the version.

Shared cleanup can remove a module cache directory recursively, owned config
links, and empty module data directories. Module-specific cleanup may also
remove helper binaries, copied fonts, or TPM; OpenCode can uninstall its CLI
outside profile cleanup. Never assume `clean` means only unlinking config.

## Repository checks

`make lint` runs Bash syntax, ShellCheck, and shfmt checks for listed scripts.
`make fmt` **rewrites** those scripts. `git diff --check` checks whitespace.
Neither compiles applications nor proves macOS/Linux runtime behavior.
