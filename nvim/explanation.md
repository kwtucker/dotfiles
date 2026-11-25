# Neovim design choices

## Keep upstream integration, customize intentionally

LazyVim owns shared capabilities, diagnostics, mappings, and language
integration. This repo extends those defaults rather than introducing a second
editor stack. fzf-lua handles normal navigation; Telescope remains for Terraform
extensions. Neo-tree is the file explorer.

Saving is explicit (`autowrite=false`). YAML and Markdown buffers disable
autoformat. Markdown wraps at word boundaries and hides line numbers/list
markers; rendering and Marksman language navigation are separate concerns.
Other filetypes can still format through LazyVim/Conform and their LSPs.

## Tool ownership is a reproducibility boundary

Mise manages cross-application tools; Mason manages editor-only packages.
Commands routed through mise should fail visibly rather than silently choosing
an unrelated Mason copy. Plugin lockfiles, Mason state, parser revisions, and
external providers have distinct lifecycles: a single CLI pin cannot freeze
all of them. The install-before-restore sequence is a current limitation, not a
reason to promise perfect lockfile reproducibility.

## Chat delegates to external agents

CodeCompanion defaults to OpenCode on macOS and Linux. Copilot is available
through an explicit adapter override, not OS-dependent or automatic fallback.
Its built-in adapters invoke Copilot's
`copilot --acp --stdio` or OpenCode's `opencode acp`; these commands come from
the installed adapter implementation. OpenCode ACP starts a private session
using project config, models, instructions, and MCP servers, not the shared
service session.

There is no Ollama integration or separate HTTP adapter configured for inline,
CLI, or background interactions. ACP agents use their own tools; CodeCompanion
tools are not automatically offered as a second tool surface. Authentication
and billing remain the external client's responsibility.

## Evidence has different strengths

Config parsing proves syntax; discovery proves a client can find a tool or
skill; a bounded live task tests behavior. None alone establishes model quality
or correct behavior on an untested OS. Keep runtime fixtures and copied
lockfiles outside this checkout, and do not run paid model sessions merely to
validate docs. See [agent evaluation](../agents/EVALUATION.md).
