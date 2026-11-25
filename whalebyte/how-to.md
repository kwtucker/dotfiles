# Vault tasks

## Create a new vault

Install the module/tools as described in [README.md](README.md). Inspect
`wbs help` to see the selected vault, identity, and recipient paths. Do not run
initialization over an existing vault or identity.

```sh
wbs init
wbs edit
wbs validate
```

Initialization creates a fresh X25519 identity, protects it with an age
passphrase prompt, and creates an empty recipient-encrypted vault. Choose and
securely retain the passphrase. The editor opens a JSON object; add values,
save, and quit. The implementation checks valid JSON, not a complete schema
for every value type. Follow [vault.example.json](vault.example.json) for the
intended key/value shape.

Back up the resulting encrypted identity, vault, and public recipient outside
this checkout. Verify a backup recovery procedure before relying on the vault
as the only copy of important credentials.

## Use a secret without printing it

In Zsh after module discovery:

```sh
wbs export EXAMPLE_KEY
```

The function exports one value into the current shell without printing it or
evaluating it as shell code. Retrieval failure leaves an existing variable
unchanged. In a terminal predating installation, source only the wrapper:

```sh
source "$XDG_CONFIG_HOME/whalebyte/function.zsh"
```

`wbs get KEY` prints the value; use it only where that exposure is intended.
`wbs list` prints key names without values, and `wbs validate` reports JSON
validity/key count. Remove an export with `unset EXAMPLE_KEY` when finished.
Already-running apps/other terminals do not receive the export; children that
inherited it retain their copy until exit.

## Back up and recover

Use `wbs help` to identify actual paths, including local overrides. Retain the
encrypted vault, matching encrypted identity, recipient, and passphrase in a
secure backup strategy. Restore matching versions; do not replace a good vault
with an unrelated identity. `wbs validate` can check decryption/JSON without
printing values, but it does not prove every intended secret survived.

Loss of both identity and its backup makes this keypair vault unrecoverable,
even if you remember the passphrase. Loss of the passphrase is also fatal
unless you have another usable identity/backup. Deleting files is not secure
erasure on snapshots, SSDs, or backup systems.

## Migrate a legacy passphrase-only vault

Back up the old encrypted `.secret` first. `wbs rekey` supports the older
**age-passphrase-encrypted JSON** format when the selected identity does not
already exist:

```sh
wbs rekey
wbs validate
```

It decrypts/validates the old JSON, creates a protected identity, and writes
the new keypair layout. Initialization/rekey commits several files in sequence,
not one multi-file transaction; retain backups and inspect partial results if
interrupted. Save the new identity and passphrase before discarding the old
backup.

Plaintext shell-assignment `.secret` files are a different legacy format.
Do not source/eval them or pass them to `rekey`. Move the old file to a protected
external backup, initialize a new vault, and manually enter values through the
editor. Keep the old copy until recovery is verified; its plaintext contents
remain sensitive in backups and snapshots.

## Troubleshoot without leaking secrets

- Missing tools: inspect PATH and provision age/jq/editor through the intended
  profile; module linking alone does not install every tool.
- Missing `wbs`: run `make whalebyte` and check `~/.local/bin` on PATH.
- Missing identity: check `wbs help` and `WBS_IDENTITY`; do not regenerate an
  unrelated identity to “repair” an existing keypair vault.
- Invalid edited JSON: correct the editor buffer or abort; existing vault
  replacement happens only after successful validation/encryption.
- Prompt problems: use an interactive terminal and retain the exact error;
  never share the passphrase, private identity, or decrypted JSON.

`~/.whalebyte/.env` is a separate plaintext, shell-sourced convenience file.
It is not the encrypted vault and must not be used as though it provides
encrypted-at-rest secret storage.
