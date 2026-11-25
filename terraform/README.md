# Terraform

Terraform CLI config, provider cache, Zsh aliases, and vendored completion.
Mise owns Terraform and related language/lint/documentation tools.

## How-to apply the configuration

Provision the profile's tools, run `make terraform` from the dotfiles root, and
open a fresh Zsh session. Inspect `terraform version` and
`$TF_CLI_CONFIG_FILE`. Project/provider initialization is a separate operation
that can download code and access remote services.

Aliases such as `tfa` and `tfd` run apply and destroy. Verify the workspace,
credentials, and plan before using them. They are not protective wrappers.

## Reference

- Config link: `$XDG_CONFIG_HOME/terraform`.
- `TF_CLI_CONFIG_FILE`: `$XDG_CONFIG_HOME/terraform/terraform`.
- [terraform](terraform): `plugin_cache_dir` uses `$XDG_CACHE_HOME/terraform/plugin-cache`.
- [aliases.zsh](aliases.zsh): `tf`, `tfi`, JSON-formatted `tfv` (requires jq),
  `tfp`, `tfa`, `tfd`, `tfs`, and `tfr`.
- Completion: `$XDG_DATA_HOME/zsh/completions/_terraform`; vendored provenance
  is recorded in [Makefile](Makefile), not fetched from a moving branch.
- `make terraform.clean`: owned config link, completion, and the module cache,
  including cached providers. It does not run destroy or remove project state.

## Explanation

Provider caches reduce repeated downloads but do not pin provider selection;
project lockfiles do that. Tool reproducibility, infrastructure state, and
credentials have different owners and backup requirements.
