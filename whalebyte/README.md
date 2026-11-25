# Whalebyte workspace and vault

Personal workspace directories and the `wbs` encrypted JSON secrets CLI.
The module is included in `infra` and `full`; its actual data and secrets remain
local under `~/.whalebyte`, not in this public checkout.

- [Create, use, back up, or migrate a vault](how-to.md)
- [Look up commands, paths, and overrides](reference.md)
- [Understand encryption and security limits](explanation.md)

## How-to install the module

Provision the selected tools and run `make whalebyte` from the dotfiles root.
It links config and `~/.local/bin/wbs`, creates private workspace/age
directories, and ensures a plaintext `.env` file exists. It does not initialize
or overwrite the encrypted vault. Other profiles can add it through ignored
`LOCAL_MODULES`.

`age`, `age-keygen`, and jq are required for vault operations; the configured
editor is needed for editing. `make whalebyte.clean` removes the config/helper
links and module cache, but leaves the workspace, identity, and vault intact.

## Explanation: personal tools versus personal data

The `temp-ssh-key` and `vpn` CLIs are shared mise tools installed by every
profile. Their source projects are not managed by this module. The `wb`
aggregator registration is likewise separate from the vault's interface.

The current vault is encrypted to an age X25519 recipient. Its private identity
is itself passphrase-encrypted. This differs from the older passphrase-only
vault format, which has a deliberate migration command. Backing up the vault
alone is insufficient; the matching identity and passphrase are also required.
