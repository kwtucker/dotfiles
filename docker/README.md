# Docker client helpers

Docker CLI completions and Zsh conveniences. Mise supplies the client binary;
this module does not install or start a Docker daemon or Rancher Desktop.

## How-to select a client

From the dotfiles root, provision the profile's tools and run `make docker`.
Use `docker --version` to inspect the client without contacting a daemon.
For Rancher Desktop's own client, use `rd-docker` after opening a shell that
loaded this module and installing Rancher Desktop separately.

## Reference

- Config: `$XDG_CONFIG_HOME/docker`, linked to this directory.
- Completion: `$XDG_DATA_HOME/zsh/completions/_docker`.
- `rd-docker`: invokes `~/.rd/bin/docker`.
- `docker_rm_all`, `docker_rmi_all`: destructive container/image removal aliases.
- `docker_prune`: `docker system prune --volumes -fa`; removes unused resources
  and volumes without confirmation. Do not use it as a routine diagnostic.
- `docker_rmi_dangling` currently contains an `imagas` typo; it is not a
  dependable cleanup command. Inspect [aliases.zsh](aliases.zsh) before use.
- `make docker.clean`: remove the owned config link, module cache, and generated
  completion; it does not prune Docker resources or uninstall the daemon.

## Explanation

Client installation is not daemon setup. Most Docker operations target the
currently selected Docker context and can affect remote hosts. Check the
context before mutating resources; these aliases are conveniences, not safety
wrappers.
