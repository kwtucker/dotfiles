# OpenCode V2

Global server/project configuration, terminal preferences, a commit command,
and shared agent guidance. The CLI pin lives in the shared mise catalog.
Every standard profile includes this module because OpenCode is Neovim's default
ACP backend on macOS and Linux.

## How-to install and inspect

From the dotfiles root, run `make opencode` after selecting/provisioning tools.
The root dependency installs [shared guidance](../agents/README.md) first.
**This module also runs mise install, reshim, and CLI pruning when its mise data
directory is writable.** It is not a link-only or read-only command.

Run `opencode` from a project to open the client, then authenticate with the
provider through the client's interactive flow. No credentials are supplied by
this module. Check skill/MCP discovery using [EVALUATION.md](../agents/EVALUATION.md).

## Reference

| File | Purpose |
| --- | --- |
| [opencode.json](opencode.json) | Server/project settings: planning agent, update notifications, formatters, instructions, worktrees, and gopls MCP |
| [cli.json](cli.json) | Terminal-only appearance, session, and diff preferences |
| `command/commit.md` | Existing file-based commit prompt; operational definition, not prose documentation |

Config is linked under `$XDG_CONFIG_HOME/opencode`. Shared instructions resolve
under `~/.agents`; worktrees default here to `~/.wt/`. Project
`opencode.json(c)` and `.opencode/opencode.json(c)` files are discovered through
ancestor directories; consult the [V2 config guide](https://opencode.ai/docs/config)
for precedence, including managed system settings.

`make opencode.upgrade` changes the installed CLI within the requested selector;
`make -C opencode prune` removes superseded CLI versions. `make opencode.clean`
removes owned config/module cache and uninstalls the CLI unless
`DOTFILES_PROFILE_CLEANUP=1`. Session data is not intentionally removed, but this
is not equivalent to OpenCode's own uninstall command.

## How-to diagnose a service problem

Start with `opencode service status`. `opencode api get /api/info` checks the
API but may start the managed service. Compare `opencode --standalone` to
isolate a shared-service issue. Restart only an unhealthy service or when
activating an updated binary. Do not delete databases or service files.

Valid config edits reload automatically; terminal settings belong in `cli.json`,
not server config. See [CLI settings](https://opencode.ai/docs/cli/config) and
[troubleshooting](https://opencode.ai/docs/troubleshooting). Redact credentials,
prompts, and file contents from logs before sharing them.

## Explanation

Client preferences and server/project behavior are different configuration
surfaces. Keeping shared skills outside the client avoids divergent instruction
copies. The global planning default does not override project-specific policy
or authorize editing while a session is in Plan mode.
