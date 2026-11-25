# Copilot

Optional Copilot CLI configuration and global MCP servers. Shared engineering
instructions and skills come from [agents](../agents/README.md).

## How-to install and verify

Select this module through `LOCAL_MODULES` or provision its tools explicitly,
then run `make copilot` from the dotfiles root. The root dependency installs
shared guidance first. Authenticate interactively in Copilot; no account token
is provisioned by this module.

Use [agent discovery checks](../agents/EVALUATION.md) in a fresh CLI session.
For Desktop, inspect **Customize → Skills/MCP** and verify its actual PATH;
do not assume every CLI preference also controls Desktop.

## Reference

| Source | Destination relative to `${COPILOT_HOME:-$HOME/.copilot}` |
| --- | --- |
| `settings.json` | `settings.json` |
| `mcp-config.json` | `mcp-config.json` |
| `instructions/engineering.instructions.md` | `instructions/engineering.instructions.md` |

The settings select planning mode and disable automatic CLI updates and
co-author attribution. The MCP file exposes `gopls mcp`; ensure gopls is on the
client's PATH through the appropriate tool profile.

`make copilot.clean` removes these checkout-owned links only. It does not
remove account state, sessions, personal instructions, or the whole Copilot home.

## How-to keep project servers and credentials local

Use a project's `.mcp.json` for project-specific servers. If it is personal and
untracked, exclude it through that project's `.git/info/exclude`; ignoring a
file does not untrack an already committed file. Reference credentials through
supported environment substitutions, never literal tokens. Desktop launched
from the Dock may not inherit a terminal's environment.

## Explanation

Only declarative config is linked; the mutable client state directory remains
local. The legacy `mcp-config.local.json` stays ignored for credential safety
but is no longer installed or merged. Portable skill definitions are not copied
into each client module.
