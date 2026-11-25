# Git configuration and signing tasks

## Configure an identity

From the dotfiles root, provision selected tools and run `make git`. This links
config, sets up the GPG agent when its shim exists, installs `wt` if missing,
and copies completion. It can download a helper; it is not a read-only check.

If `git/config.local` does not exist, copy `git/config.local.example` to that
ignored path, then keep the identity/auth blocks appropriate to this machine.
If it exists, edit it without overwriting unrelated settings. For optional
GitHub-remote identity routing, create ignored `git/config.github` as described
in the example file.

Inside the repository where you will commit, verify the effective values:

```sh
git config --show-origin --get user.name
git config --show-origin --get user.email
```

Do not assume the authenticated CLI account and Git author identity match.

## Generate and copy a signing key

Install the [bin helper](../bin/README.md) with `make bin`. GnuPG and Pinentry
come from the Git-owned mise tool set; provision them before generating keys.
For agent-only deployment after tool installation, run
`make -C git gpg-install` from the dotfiles root.

First check for an existing key:

```sh
gpg-key list
```

If none suitable exists, run:

```sh
gpg-key generate
```

Enter your name and an email verified on the signing platform, review the
identity, and confirm. The helper creates an Ed25519 signing-only key with a
one-year expiration; GPG/Pinentry handles the passphrase. Account or project
policies may require a different algorithm or expiration, in which case use GPG's own
interactive generation workflow instead.

Find the key ID or full fingerprint with `gpg-key list`, then:

```sh
gpg-key copy REPLACE_WITH_KEY_ID
```

Use a hexadecimal selector without spaces. Ambiguous matches are refused.
This exports only the public key. macOS uses `pbcopy`; supported Linux desktop
sessions use `wl-copy` or `xclip`. Without a clipboard tool, armor is printed
on stdout instead. A successful copy does not upload anything.

Paste the public key into your hosting platform's signing-key settings. Give
it a descriptive machine/purpose label. Never upload the private key or put
it in this checkout. Back up the private key and any revocation certificate
securely using GPG's own guidance; public-key export is not a private-key backup.

## Enable signing for one repository

Run these commands **inside the intended repository**, using the chosen key's
full fingerprint:

```sh
git config --local user.signingkey REPLACE_WITH_FINGERPRINT
git config --local gpg.format openpgp
git config --local commit.gpgsign true
```

Check the effective email and key before your next intentional commit. These
commands change `.git/config`; they do not create a commit. For broader
machine/per-account defaults, merge the settings into ignored identity files
instead of using `git config --global`, which could write through the tracked
global config link.

Inspect an existing signed commit with `git log -1 --show-signature`. Local
verification and a platform's “Verified” label are different checks; the
platform also needs the public key and matching verified email.

## Repair a passphrase prompt

In the terminal/pane where you will use GPG:

```sh
export GPG_TTY="$(tty)"
gpg-connect-agent updatestartuptty /bye
```

The generated config uses `pinentry-tty`, a plain-text prompt rather than a
full-screen curses dialog. Typed passphrases may remain invisible intentionally.
After changing agent config, use `gpgconf --reload gpg-agent`.

If manual generation still cannot display a prompt, cancel the attempt and use
`gpg --pinentry-mode loopback --full-generate-key` for that invocation. This asks
directly through GPG and does not change permanent agent settings. Check whether
a key was saved before retrying; do not create duplicates blindly or share your
passphrase in diagnostics.
