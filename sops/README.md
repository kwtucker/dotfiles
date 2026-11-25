# SOPS

Structured-file encryption through SOPS and age, using a passphrase-protected
age identity decrypted on demand. This is separate from the `wbs` JSON vault.

## How-to configure an identity

Provision the selected tools and run `make sops` from the dotfiles root. You
need an existing encrypted age identity: create one through the
[vault setup guide](../whalebyte/how-to.md#create-a-new-vault), or supply your own.

The helper defaults to `$XDG_CONFIG_HOME/age/wbs-identity.age`. If your vault
uses its fallback HOME-based identity, set the actual path in ignored
`zsh/local`, for example:

```sh
export WBS_IDENTITY="$HOME/.whalebyte/.age-identity"
```

Read the corresponding **public recipient** file (`wbs-recipient` in the XDG
layout or `.age-recipient` in the fallback layout) and add that public `age1...`
value to the target project's `.sops.yaml`:

```yaml
creation_rules:
  - path_regex: secrets/.*\.yaml$
    age: age1REPLACE_WITH_PUBLIC_RECIPIENT
```

Do not run `age-keygen -y` directly on the encrypted identity file or paste the
private identity into a project. For a non-Zsh shell, explicitly export:

```sh
export SOPS_AGE_KEY_CMD="$HOME/.local/bin/sops-age-key-from-wbs"
```

## How-to edit encrypted files

Inside the intended project, use `sops edit secrets/config.yaml` to create or
edit an encrypted file. `sops -d FILE` prints plaintext to stdout; never redirect
that into logs or this checkout. `sops -e -i FILE` encrypts in place and
`sops -d -i FILE` leaves plaintext on disk—use those only deliberately.

## Reference

- Config link: `$XDG_CONFIG_HOME/sops`; [env.zsh](env.zsh) exports the helper.
- `SOPS_AGE_KEY_CMD`: `~/.local/bin/sops-age-key-from-wbs`.
- `WBS_IDENTITY`: overrides the encrypted identity path used by that helper.
- Installation creates/protects `$XDG_CONFIG_HOME/age` with mode `700`.
- `make sops.clean`: shared config/cache cleanup and removal of the recognized
  managed helper. Age identities and project encrypted files are not removed.

## Explanation

The helper runs age decryption and feeds its private output to SOPS, avoiding a
permanent plaintext identity file. It does not make secrets invisible to the
host or prevent SOPS/editor temporary files. A terminal is needed for
interactive passphrase entry. Sharing the vault identity is convenient, but
independent identities are preferable when you need separate access boundaries.
Back up identities and passphrases; see the [vault security explanation](../whalebyte/explanation.md).
