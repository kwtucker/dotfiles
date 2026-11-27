# Git

Git defaults, identity routing, aliases, the pinned `wt` worktree helper,
portable GPG agent setup, and a shell export that reuses an authenticated GitHub
CLI login. Personal identities, credentials, and private keys remain outside
tracked configuration.

## Choose your task

- [Install config or set an identity](how-to.md#configure-an-identity)
- [Generate and copy a signing key](how-to.md#generate-and-copy-a-signing-key)
- [Enable signing for one repository](how-to.md#enable-signing-for-one-repository)
- [Repair a passphrase prompt](how-to.md#repair-a-passphrase-prompt)
- [Look up aliases, paths, and cleanup](reference.md)

## Explanation: identity is not authentication

Git's author name/email, transport credentials, and signing key serve different
purposes. An SSH key used to push is not automatically a GPG signing key; adding
a public key to a hosting service does not enable local commit signing.

The shared config includes `git/config.local` first, then optional
`git/config.github` for matching GitHub remotes. Both are ignored. HTTPS GitHub
push URLs are rewritten to SSH; HTTPS fetch stays HTTPS and can use the
configured credential cache. Host-specific authentication and multiple accounts
belong in local overrides, not universal hard-coded identities.

Portable GPG behavior lives in the tracked setup helper/template. Each computer
generates an ignored config with its mise Pinentry path; the GPG home itself is
never symlinked into this repository. See the [reference](reference.md#gpg-paths).

For shared installation semantics, use the [project how-to guides](../docs/README.md#how-to-guides).
