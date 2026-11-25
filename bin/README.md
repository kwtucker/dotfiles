# Helper scripts

Executable, platform-neutral conveniences installed in `~/.local/bin`.
Currently this module contains [gpg-key](gpg-key).

## How-to install and use

From the dotfiles root:

```sh
make bin
gpg-key --help
gpg-key list
gpg-key copy KEY_ID
```

For a new signing key, use `gpg-key generate`. It asks for a name, verified
email, and confirmation, then creates an Ed25519 signing-only key expiring in
one year. GPG/Pinentry owns passphrase entry; the script never reads or stores
your passphrase. See the [signing-key guide](../git/how-to.md#generate-and-copy-a-signing-key).

## Reference

| Command | Effect |
| --- | --- |
| `gpg-key generate` | Interactive key creation; changes the GPG home |
| `gpg-key list` | Show secret-key availability, IDs, fingerprints, and identities |
| `gpg-key copy KEY_ID_OR_FINGERPRINT` | Export one public key in armor; change clipboard or print fallback |
| `gpg-key --help` | Show usage without requiring GPG |

`copy` requires a hexadecimal selector, resolves it to exactly one primary
fingerprint, and refuses ambiguous matches. It never exports private keys.
Clipboard backends are `pbcopy`, Wayland's `wl-copy`, and X11's `xclip`; absent
tools cause public-key output on stdout, while clipboard errors fail visibly.

GPG and Pinentry are owned by the [Git module's tool set](../git/reference.md),
not installed by `make bin`. `make bin.clean` removes exact owned script links,
never the shared `~/.local/bin` directory or unrelated user scripts.

## Explanation

The generic [Makefile](Makefile) installs executable files from this directory.
Non-executable docs are skipped. Uploading public keys and enabling Git signing
remain separate, explicit tasks rather than side effects of key generation.
