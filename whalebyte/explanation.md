# Vault encryption and security boundaries

## A protected identity, not just a vault passphrase

The current vault uses age X25519 recipient encryption. Its private age identity
is stored encrypted under a passphrase. Unlocking that identity permits vault
decryption and allows the same identity to serve [SOPS](../sops/README.md).
The public recipient is safe to use in encryption rules; the private identity
is not.

This differs from the older passphrase-only age JSON vault. The `rekey`
subcommand is a format migration, not general rotation of an existing keypair.
The vault alone is not recoverable without a matching identity and passphrase.

## Plaintext exists during use

Operations create a private temporary directory beside the vault. Decrypted
JSON and, during initialization/migration, the plaintext identity exist in
temporary files. Ordinary edits compare against the original JSON, validate,
encrypt to another temporary file, then replace the vault by rename. Traps
clean temporary files on normal exit and handled interruptions.

An atomic vault rename is not a transaction across the identity, recipient,
and vault. Initialization/rekey writes these in sequence; power loss, forceful
termination, filesystem failures, or snapshots can leave partial state or
copies. Backups remain necessary. Cleanup is not secure erasure.

## Environment exports have a separate threat model

The Zsh wrapper exports values without printing or evaluating them. They still
live in shell memory and are inherited by future child processes. Unsetting a
variable does not retract copies already inherited by a running child. Other
terminals or apps launched from the Dock do not automatically receive it.

The plaintext `.env` file is sourced by Zsh; it is not encrypted and must be
trusted as executable shell input. It is separate from `.secret`.

## Limits

- Encryption protects stored files, not secrets from root, device owners,
  monitoring/EDR agents, or compromised editor/client processes.
- `wbs get` prints secret values; avoid logs, transcripts, and repository files.
- JSON parsing is not a strict schema validating every intended value type.
- Editor persistence is disabled for the plaintext buffer, but plugins and
  external integrations are separate processes/behaviors to review.
- Tests of syntax or successful decryption do not establish backup recovery,
  protection against every host threat, or behavior on an untested platform.
