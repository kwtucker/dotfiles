# whalebyte

Personal, **local-only** module. It manages `~/.whalebyte` (code, notes, and a
passphrase-protected secrets vault) and installs the `wbs` secrets CLI. It is
enabled per-machine via `modules.local.mk` (`LOCAL_MODULES = whalebyte`) and is
intentionally **not** part of the public module set or the workspace image.

## Secrets vault (`wbs`)

`wbs` stores secrets as JSON in a single [age](https://github.com/FiloSottile/age)
file (`--passphrase`, scrypt) at `~/.whalebyte/.secret`. The vault is only an
opaque encrypted blob on disk; plaintext exists only in a `0700` temp directory
beside the vault while a command runs, and is removed on exit — including on
error or interruption.

```
~/.whalebyte/
├── .env          # plaintext, shell-sourced (see below)
├── .secret       # age-encrypted JSON vault  (0600)
├── code/
└── ...
```

### Dependencies

`age` and `jq` come from `mise.toml` (`mise install`, or `./install`). Neovim is
needed only to edit. `wbs` fails with a clear message if a dependency is missing.

### Setup (first time)

```sh
# 1. Enable the module locally (once per machine).
echo 'LOCAL_MODULES = whalebyte' >> modules.local.mk   # if not already present
make whalebyte                                          # links the module + installs ~/.local/bin/wbs
# 2. Create the vault and choose a passphrase.
wbs init
wbs                                                     # add secrets in Neovim, save, quit
```

`wbs init` refuses to touch an existing vault. `make whalebyte` never creates or
overwrites `.secret`.

### Commands

| Command | Purpose |
| --- | --- |
| `wbs` / `wbs edit` | Decrypt, edit in Neovim, validate, re-encrypt |
| `wbs init` | Create a new empty vault (fails if one exists) |
| `wbs get KEY` | Decrypt and print one value to stdout |
| `wbs validate` | Decrypt and validate the JSON, report the key count |
| `wbs help` | Usage |

`WHALEBYTE` overrides the vault directory; `WBS_EDITOR` overrides the editor.

### Consuming secrets

Nothing is auto-exported at shell startup. Pull values on demand:

```sh
export SPOTIFY_ID="$(wbs get SPOTIFY_ID)"
SPOTIFY_SECRET="$(wbs get SPOTIFY_SECRET)" command-uses-it
```

### How it works

1. Decrypt `.secret` into `$WHALEBYTE/.wbs.XXXXXX/plain.json` (`0600`).
2. Open Neovim with swap/backup/undo/shada disabled — `-n -i NONE` plus a
   post-load `set nobackup nowritebackup noundofile noswapfile` that overrides
   `undofile = true` in the shared nvim config.
3. Validate the edited JSON with `jq -e .`.
4. Encrypt to a temp file, `chmod 600`, then atomically `mv` it over the vault.
5. Remove the temp directory via an `EXIT`/`INT`/`TERM` trap.

Any failure — wrong passphrase, invalid JSON, editor error, Ctrl-C — aborts
before step 4, so the last valid vault is always intact.

### Recovery

- **Vault lost, passphrase known:** restore a backup of `.secret` (the encrypted
  file is safe to keep in normal backups/cloud storage).
- **Passphrase lost:** the data is **unrecoverable**. There is no recovery key,
  no keyfile, and nothing stored in the repository. Back up the passphrase.
- **Vault corrupt / wrong format:** `wbs validate` reports it; nothing is
  overwritten until a decrypt → edit → validate → encrypt cycle succeeds.

### Troubleshooting

| Symptom | Cause / fix |
| --- | --- |
| `missing dependency 'age'` | `mise install` (or `./install`) so `~/.local/share/mise/shims` is on PATH |
| `incorrect passphrase` | Wrong passphrase; the vault is unchanged |
| `vault is not valid JSON` | The vault (or your edit) isn't JSON — `wbs` refuses to encrypt invalid content |
| Edited content rejected | Fix the JSON; answer `y` to re-open or `n` to abort (vault unchanged) |
| `wbs: command not found` | Run `make whalebyte` to link `~/.local/bin/wbs`; ensure `~/.local/bin` is on PATH |
| Left the passphrase blank at init | age generates a random passphrase and prints it **once** — save it or the vault is unrecoverable |

### `.env` (not encrypted)

`~/.whalebyte/.env` remains plaintext and is sourced by `.zshrc`. It is a
separate, non-secret convenience channel; the encrypted vault replaces only the
old `.secret` file.

### Security limitations

- Secrets are protected **at rest**. While a command runs, plaintext exists in
  memory and in a private temp file; anyone with privileged access to the machine
  (root, monitoring/EDR agents) can observe it. Secrets that must stay hidden
  from the device owner should not live on the device at all.
- `wbs get KEY` prints a secret to stdout — don't redirect it into logs, shell
  history, or the repository.
- Deleting a plaintext file is not a secure erase (SSD wear-levelling, APFS
  snapshots, Time Machine, backups).

### Migrating from a plaintext `.secret`

The old `.secret` was shell assignments (`export KEY="value"`). To move it in:

```sh
cp ~/.whalebyte/.secret ~/.whalebyte/.secret.bak   # keep a backup until verified
wbs init
wbs                                                # add the keys as JSON, e.g. {"KEY":"value"}
wbs get KEY                                        # verify
rm ~/.whalebyte/.secret.bak                        # then remove the plaintext copy
```

The vault stores a JSON object of string keys → values, e.g.:

```json
{
  "SPOTIFY_ID": "…",
  "SPOTIFY_SECRET": "…"
}
```

See `vault.example.json` for the shape.
