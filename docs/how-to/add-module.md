# Add a module

Use this guide when introducing a tracked configuration module. Read the
repository [agent guide](../../AGENTS.md) and an existing similar module first.

1. Create `MODULE/Makefile` and its configuration. Include `../env.mk` where
   appropriate, quote paths, and use tabs for recipes.
2. Install configuration through `scripts/lib/link.sh`; refuse conflicts by
   default and support explicit adoption. Never symlink an application's entire
   credentials/session directory into Git.
3. Implement cleanup for only owned links/artifacts. Review the shared cleanup
   helper's cache deletion behavior before depending on it. A profile switch
   calls `clean` with `DOTFILES_PROFILE_CLEANUP=1`.
4. Declare `TOOLS_MODULE` in `tools.mk`, even if empty. Put tool versions in
   `mise.toml`, preserving backend-qualified names and version-range policy.
5. Add the module to `profiles.mk` only if it should install by default. Every
   module Makefile is discovered automatically; opt-in availability needs no
   separate optional-module list.
6. Extend the read-only expected-link model when installation owns additional
   paths beyond the normal XDG config directory.
7. Add a README describing purpose, prerequisites, tasks, paths, overrides, and
   cleanup. Link shared guides; separate long how-to/reference/explanation
   content only when useful.

Validate with `make tools.check`, appropriate syntax/config parsing, and
`git diff --check`. Exercise installers in a temporary fake HOME with isolated
XDG variables. Inspect recipes before running even `make -n`, because recursive
recipes may execute. Put no persistent tests, fixtures, or test frameworks in
this checkout. Do not run `./install`, broad upgrades, or real-home cleanup as
a validation shortcut.
