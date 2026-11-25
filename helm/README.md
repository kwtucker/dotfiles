# Helm

Zsh completions and a Rancher Desktop client alias. Mise owns the Helm binary;
cluster credentials and chart repositories are not provisioned here.

## How-to install and select a client

Provision the profile's tools, then run `make helm` from the dotfiles root.
Open a fresh Zsh session and inspect `helm version`. Use `rd-helm` only when
Rancher Desktop's `~/.rd/bin/helm` is installed.

Before an install, upgrade, or uninstall, confirm the target Kubernetes context
and namespace. This module does not wrap Helm operations with extra safety
checks.

## Reference

- Config link: `$XDG_CONFIG_HOME/helm`.
- [aliases.zsh](aliases.zsh): `rd-helm` selects Rancher Desktop's client.
- Completion: `$XDG_DATA_HOME/zsh/completions/_helm`.
- `make helm.clean`: shared config/cache cleanup and removal of `_helm`;
  no chart releases or cluster resources are deleted.

## Explanation

The generic client and Rancher Desktop client can coexist. Their installation
source does not determine which cluster your credentials/context select.
Local repository metadata and credentials should not be added to Git.
