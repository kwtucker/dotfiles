# Go environment

Shared Go runtime, language-server, formatting, and analysis tools, plus a small
Zsh environment. This is a configuration module, not a Go application.

## How-to install and inspect

Select a profile including `golang`, provision its tools, and run `make golang`
from the dotfiles root. Open a new Zsh session and inspect `go version` and
`go env GOBIN`. Project tool pins belong in the project's mise configuration.

For editor integration, see [Neovim tooling](../nvim/reference.md). Do not run
Go tests in this dotfiles checkout merely to validate documentation or config.

## Reference

- Config link: `$XDG_CONFIG_HOME/golang`.
- [env.zsh](env.zsh): `GO111MODULE=on`, `GOBIN=$HOME/.local/bin`.
- Tool ownership: Go, gopls, goimports, gofumpt, staticcheck, govulncheck, and
  golangci-lint in `TOOLS_golang`; pins live in [mise.toml](../mise.toml).
- Completion: `$XDG_DATA_HOME/zsh/completions/_golangci-lint`.
- `make golang.clean`: owned config link/module cache and completion removal;
  no application sources or `GOBIN` binaries are removed by this target.

## Explanation

Mise's `go.set_gobin=false` keeps the shell-owned `GOBIN` choice separate from
tool installation. Shared developer tools and editor-specific tools have
different owners; Neovim should not silently replace mise-managed Go tools with
competing Mason copies.
