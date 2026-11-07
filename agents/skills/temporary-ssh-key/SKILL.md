---
name: temporary-ssh-key
description: Generate a temporary Ed25519 SSH key pair with the installed temp-ssh-key CLI and share only its public key as text, a terminal QR code, or a PNG so it can be authorized on GitHub, GitLab, or an SSH server without signing in on this machine. Run the flow in a history-isolated shell. Keep private keys outside the repository, preserve existing SSH configuration, and explain one-time use, revocation, and cleanup.
---

# Temporary SSH key

Create a disposable authentication key for the current machine and share only its
public key so the user can authorize it elsewhere. The usual case is temporary git
access from a machine where the user must not sign in to their personal account (for
example, a public or untrusted computer): scan the public key as a QR code on a
trusted device, authorize it there, use it for the git operation, then revoke it and
delete it locally.

This skill owns policy and procedure. The installed `temp-ssh-key` executable owns
the mechanics: private temporary directory, Ed25519 generation, verification,
public-key display, isolated shell, session exports, and guarded local cleanup. The
tool never contacts a remote, edits SSH or Git configuration, adds a key to an agent,
or revokes authorization.

Read `reference.md` for host-specific UI steps, port-443 syntax, installation and
bootstrap details, history internals, identity/signing details, cleanup guards, and
troubleshooting. For flags, use `temp-ssh-key <command> --help`; do not duplicate the
CLI reference here.

## Preflight

Before doing anything else, verify the tool is available and new enough:

```sh
command -v temp-ssh-key
temp-ssh-key --version
```

Require `0.1.3` or newer. If it is missing or older, stop and tell the user how to
install or upgrade it. Do not download and run a binary on an untrusted machine
without the user's explicit approval and a checksum check; see `reference.md`.

## Hard rules

- Generate only when the user asks and writes are permitted. Respect plan/read-only
  mode.
- Identify the destination (GitHub, GitLab, another git host, or an SSH server). Do
  not contact or change it without separate authorization.
- Passphrases go only to the user's interactive `ssh-keygen` prompt. Never ask for,
  print, or place one in chat, arguments, environment variables, files, or history.
- `create`, `shell`, `start`, and `cleanup --remove` are the user's commands. They
  need their terminal; do not run them through a tool call. The agent may run
  non-interactive commands such as `--version`, `show`, `env`, and the print-only
  form of `cleanup`.
- An unencrypted key only after explicit agreement, using `--allow-unencrypted`.
- Never sign in to the personal account on this machine: no `gh auth login`,
  `glab auth login`, browser session, or credential prompt. Authorize and revoke on
  the trusted device.
- Never read, print, upload, commit, or copy the private key. Do not add it to an
  agent or edit SSH/Git configuration automatically.
- Deleting local files is not revocation. Revoke remotely on the trusted device.
- Always run the flow inside a history-isolated shell. Use `start`, or `shell` then
  `create`; do not generate outside one.
- On a public or untrusted computer, use this only where personal pushes are
  permitted; do not bypass security controls or monitoring.

## Flow

### 1. Create the key inside an isolated shell

Two valid flows. Prefer the strict flow when the user wants even the generation
command kept out of the parent shell's history.

**Convenience — one command:**

```sh
temp-ssh-key start --format qr
```

`start` creates the key, then replaces itself with a history-isolated shell. It
exports `KEY_DIR`, `KEY`, and `KEY_FINGERPRINT` there. The parent shell records only
`start`.

**Strict — generate inside the isolated shell:**

```sh
temp-ssh-key shell
eval "$(temp-ssh-key create --format qr)"
```

`create` prints only eval-safe `KEY_DIR` and `KEY_FINGERPRINT` assignments to stdout;
the public key, QR code, PNG path, and warnings go to stderr. `shell` starts `zsh -f`
by default, or `bash --noprofile --norc` with `--shell bash`.

Both flows disable history storage for the child shell and export
`TEMP_SSH_KEY_ISOLATED=1` to prevent nesting. If the user is already in an isolated
shell, `start` refuses and points at `create`; run `create` there. Run the rest of the
flow inside that shell and `exit` when done.

`create` prompts for a passphrase through `ssh-keygen`. `--allow-unencrypted` skips
the prompt and is never implicit. This is shell-history isolation, not Git config
isolation.

### 2. Share and authorize

- Prefer `qr`; use `png` if the terminal cannot render it (open locally, never
  upload); use `text` for copy/paste.
- Transfer only the public key. The QR payload is the public key, not a link.
- The public key and fingerprint are not secret. The private key is.

Scan it on the trusted device and add it to the intended account with a temporary
title such as `temp-ssh-2026-11-06`:

- GitHub: Settings → SSH and GPG keys → New SSH key → **Authentication Key**.
- GitLab: Preferences → SSH Keys (optional expiry).
- SSH server: append to the destination user's `authorized_keys`; do not edit it
  remotely unless separately requested.

Do not claim a scan or fingerprint match unless it actually happened.

### 3. Use the key

```sh
eval "$(temp-ssh-key env "$KEY_DIR" --name "Your Name" --email "you@example.com")"
```

This exports `KEY_DIR`, `KEY`, `GIT_SSH_COMMAND`, a `core.sshCommand` override, and
the four `GIT_AUTHOR_*`/`GIT_COMMITTER_*` variables. `--name` and `--email` must be
given together or omitted. By default it also ignores global/system Git config
(rewrite rules, the computer's configured identity, signing) for that shell; add
`--no-isolate-config` to keep that config.

Then:

```sh
ssh -F /dev/null -o IdentitiesOnly=yes -i "$KEY" -T git@github.com
git commit -m "..."
git push git@github.com:OWNER/REPOSITORY.git HEAD:BRANCH
```

- `-F /dev/null` bypasses `~/.ssh/config`; `IdentitiesOnly=yes` prevents other
  identities. Keep host-key verification enabled.
- GitHub greets the username and normally exits 1 on success. GitLab exits 0. If the
  wrong account is greeted, stop.
- Push to an explicit personal SSH URL; do not change remotes permanently.
- Port 22 blocked: see `reference.md` for the 443 endpoints and `core.sshCommand`
  form.
- Never `--force` or disable host-key verification. Providing these commands does
  not authorize executing a push.

### 4. Revoke, then clean up

On the trusted device, delete the temporary key:

- GitHub: Settings → SSH and GPG keys.
- GitLab: Preferences → SSH Keys.

Confirm revocation before local deletion. Then, in the user's terminal:

```sh
temp-ssh-key cleanup "$KEY_DIR"            # prints the commands; deletes nothing
temp-ssh-key cleanup "$KEY_DIR" --remove   # prompts per file, then rmdir
```

`--remove` must be the user's command, not the agent's. If deletion is declined or
files remain, report incomplete cleanup. Never glob temporary directories or reuse
paths from earlier sessions.

Finally, in the isolated shell: `unset KEY_DIR KEY KEY_FINGERPRINT` and `exit`.

## Decision points

- **Flow:** `start` for convenience; `shell` then `create` when generation itself
  must happen inside the isolated shell.
- **Format:** QR when the account is on another device; PNG if the terminal cannot
  render the QR; text for another channel.
- **Host:** GitHub and GitLab are above; SSH-server details are in `reference.md`.
- **Identity:** use `env` or per-command `-c user.name=... -c user.email=...`. Do not
  edit config. Use the account's noreply address if its private email is blocked.
- **Rewrite rules:** prefer an explicit `git@...` URL. Inspect and bypass when the
  machine's rules are unknown; `reference.md` has the commands.
- **Signing:** do not sign with the temporary key unless intended; isolated config
  (the `env` default) or per-command `-c commit.gpgsign=false` avoids the machine's
  signing setup.

## Stop conditions

- `temp-ssh-key` is missing or older than `0.1.3`.
- The session is not in a history-isolated shell.
- The user cannot provide an interactive terminal for `create`, `shell`, `start`,
  `--remove`, or a passphrase.
- The greeted account is not the intended one.
- Revocation is not confirmed.
- Cleanup refuses the directory or files remain.
- The destination or authorization is ambiguous.
