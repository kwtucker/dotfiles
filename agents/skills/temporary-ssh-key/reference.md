# temporary-ssh-key reference

Details for `SKILL.md`. Read only the section you need. The installed CLI's
`--help` and the project README are authoritative for flags.

## Installation and preflight

On a machine managed by these dotfiles, `mise.toml` pins the release:

```sh
mise install
temp-ssh-key --version
```

On another trusted machine:

```sh
mise use -g github:kwtucker/temp-ssh-key@0.2.3
# or
go install github.com/kwtucker/temp-ssh-key/cmd/temp-ssh-key@latest
```

On an untrusted machine, prefer a one-off pinned download over a persistent
install, and get the user's explicit approval first:

```sh
VERSION=0.2.3
case "$(uname -s)" in
  Linux) os=linux ;;
  Darwin) os=darwin ;;
  *) echo "unsupported OS"; exit 1 ;;
esac
case "$(uname -m)" in
  x86_64|amd64) arch=amd64 ;;
  arm64|aarch64) arch=arm64 ;;
  *) echo "unsupported architecture"; exit 1 ;;
esac
base="https://github.com/kwtucker/temp-ssh-key/releases/download/v$VERSION"
archive="temp-ssh-key_${VERSION}_${os}_${arch}.tar.gz"
tmp="$(mktemp -d)"
cd "$tmp"
curl -fsSLO "$base/$archive"
curl -fsSLO "$base/checksums.txt"
grep " $archive\$" checksums.txt | sha256sum -c -
# macOS without GNU coreutils: grep " $archive\$" checksums.txt | shasum -a 256 -c -
tar -xzf "$archive"
./temp-ssh-key --version
```

Delete the temporary directory and archive when the session ends. Do not install to a
persistent `PATH` location on a machine you do not trust unless the user asks.

Require `0.2.3` or newer. If the tool is missing or older, stop rather than silently
downloading a different version.

## Output contract

| Command | stdout | stderr |
|---|---|---|
| `create` | only `KEY_DIR='...'` and `KEY_FINGERPRINT='...'` | public key, QR/PNG path, warnings, notes |
| `start` | normally empty because the process is replaced | public key, QR/PNG path, next steps, warnings, notes |
| `show` | the requested artifact | fingerprint |
| `env` | eval-safe exports | nothing |
| `cleanup` (print mode) | literal `rm -i`/`rmdir` commands | revocation warning and note |

The split for `create` is what makes this safe:

```sh
eval "$(temp-ssh-key create --format qr)"
```

Only stdout is evaluated. The QR code still renders because it is written to stderr.
`create` therefore checks stdin (passphrase) and stderr (QR output), not stdout;
stdout being a pipe under command substitution is expected. `show --format qr`
writes to stdout and does need stdout to be a terminal.

## Key creation internals

- `create` makes a fresh `temp-ssh-key.*` directory under `--base` (default
  `$TMPDIR` or `/tmp`) with mode 700. `--base` must be an absolute, existing
  directory.
- It refuses to overwrite an existing private or public key path.
- It generates Ed25519 with `ssh-keygen` and the `--comment` value (default
  `temporary-ssh-access`; never use an email unless the user asks). The comment must
  be one non-empty line of printable text, at most 256 bytes.
- It verifies that the private key is a regular, non-symlink, non-empty file at mode
  600. It parses the public key as one OpenSSH `ssh-ed25519` line and computes the
  `SHA256:...` fingerprint from the key blob. It does not call `ssh-keygen -lf`.
- `show`, `env`, and `shell KEY_DIR` re-verify the directory and confirm that the
  private key's embedded public half matches `id_ed25519.pub` before using it. This
  needs no passphrase. A mismatched or malformed pair is rejected.
- On failure it removes only the partial files it created and the empty directory.
- `create` needs an interactive terminal for the passphrase. `--allow-unencrypted`
  removes that requirement and skips the passphrase; use it only after explicit
  agreement.
- `--format qr` needs an interactive terminal. `--format png` does not.
- `create` does not enter a shell. Use `start`, or `shell` then `create`.

`start` runs the same creation, suppresses the stdout assignments, exports the full
session environment (key paths, `GIT_SSH_COMMAND`, `GIT_TERMINAL_PROMPT=0`, config
override, optional identity, and config isolation), and replaces the process with
the isolated shell. It refuses to run inside an already isolated shell. If the
shell is missing or cannot start, it removes the newly created key directory.

## QR and PNG

- The QR payload is the actual public-key text, not a hosted link; the public key is
  public.
- Terminal QR uses half-block characters (two module rows per text row) without
  ANSI color and requires a TTY. The CLI
  refuses captured output.
- If the terminal cannot render it or the scan will not lock, use `--format png`. The
  PNG is written inside the key directory and is replaced atomically on repeat runs.
  Open it locally; never upload the PNG or use an external QR service.
- Verify the decoded text starts with `ssh-ed25519`, is one line, and compare its
  fingerprint with the destination when possible. Do not claim a match that was not
  checked.

## Host details

- **GitHub:** Settings → SSH and GPG keys → New SSH key, type **Authentication Key**
  (not Signing Key unless the user intends to sign). Temporary title such as
  `temp-ssh-2026-11-06`.
- **GitLab:** Preferences → SSH Keys, optional expiration; authentication usage.
- **SSH server:** the destination user's `~/.ssh/authorized_keys`, one key per line;
  preserve existing entries; do not install remotely unless separately requested.

## Port 443

Use when port 22 is blocked; keep the personal host in the URL:

```sh
# GitHub
ssh -F /dev/null -o IdentitiesOnly=yes -o Hostname=ssh.github.com -p 443 \
  -i "$KEY" -T git@github.com
# GitLab
ssh -F /dev/null -o IdentitiesOnly=yes -o Hostname=altssh.gitlab.com -p 443 \
  -i "$KEY" -T git@gitlab.com
```

For fetch or push, add the same options inside `core.sshCommand`:

```sh
git -c core.sshCommand="ssh -F /dev/null -o IdentitiesOnly=yes -o Hostname=ssh.github.com -p 443 -i '$KEY'" ...
```

The exported `core.sshCommand` from `env` can be overridden per command with `-c`.
Host-key verification still applies; expect a first-connect prompt for the alternate
hostname.

## Authentication check

```sh
ssh -F /dev/null -o IdentitiesOnly=yes -i "$KEY" -T git@github.com
```

GitHub greets the intended username and normally exits 1 even on success. GitLab
uses `git@gitlab.com`, greets `Welcome to GitLab, @user!`, and exits 0. Other hosts
vary; exit status alone is not proof. Stop if the wrong account is greeted.

## Rewrite rules

`insteadOf` affects fetch and push; `pushInsteadOf` affects push only. Inspect both:

```sh
git config --show-origin --get-regexp '^url\.'
git remote get-url origin          # fetch/clone URL
git remote get-url --push origin   # push URL, includes pushInsteadOf
```

`git remote get-url --push` needs an existing remote. To bypass global/system rules
and the computer's configured identity for one command:

```sh
GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_SYSTEM=/dev/null git ...
```

Repository-local rules still apply. Prefer an explicit `git@...` URL and do not
change remotes permanently. `env` ignores global/system config by default; use
`--no-isolate-config` to keep it for the session. The command-level
`GIT_CONFIG_KEY_n`/`GIT_CONFIG_VALUE_n` override takes precedence over file-based
`core.sshCommand`.

## Identity and signing

Ask the user for the session's author name and email rather than guessing or
inheriting them from the untrusted machine. Pass them verbatim to `--name` and
`--email`, or use per-command `-c user.name=... -c user.email=...`; omit identity
for fetch-only sessions. Never copy the example placeholders or assume a repository
identity without confirmation.

Per-command:

```sh
git -c user.name="Your Name" -c user.email="you@example.com" commit -m "..."
git -c user.name="..." -c user.email="..." var GIT_AUTHOR_IDENT
git -c user.name="..." -c user.email="..." var GIT_COMMITTER_IDENT
```

For a session, `temp-ssh-key env --name ... --email ...` exports
`GIT_AUTHOR_NAME`, `GIT_AUTHOR_EMAIL`, `GIT_COMMITTER_NAME`, and
`GIT_COMMITTER_EMAIL`.

- Do not change global config; do not rewrite existing commits.
- If the host blocks the account's private email, use its noreply address
  (`ID+USERNAME@users.noreply.github.com` on GitHub).
- Check for existing signing before committing:

  ```sh
  git config --show-origin --get user.email
  git config --get commit.gpgsign
  git config --get user.signingkey
  ```

  Unless signing with the temporary key is intended, use
  `-c commit.gpgsign=false`, or rely on the `env` default config isolation.

### Dotfiles alternative: config.local

If the machine is managed by these dotfiles and the user prefers a file, confirm the
included path: `${XDG_CONFIG_HOME:-$HOME/.config}/git/config.local` (normally
`~/.config/git/config.local`). Have the user privately record the existing
`user.email`, including whether it was absent or had multiple values. Do not dump the
full config, which may contain credentials, and do not edit it without separate
authorization. Restore the exact previous setting on cleanup even if later steps
fail.

## Isolated shell

Two entry points:

```sh
temp-ssh-key start --format qr \
  --name "Your Name" --email "you@example.com"  # create, then enter the shell
temp-ssh-key shell                             # enter the shell, then create inside it
```

The child is `zsh -f` by default or `bash --noprofile --norc` with `--shell bash`.
It sets `HISTFILE=/dev/null` and `SAVEHIST=0` (zsh) or `HISTSIZE=0` (bash), and
`TEMP_SSH_KEY_ISOLATED=1`. `start` and `shell KEY_DIR` export the full session
environment: `KEY_DIR`, `KEY`, `KEY_FINGERPRINT`, `GIT_SSH_COMMAND`,
`GIT_TERMINAL_PROMPT=0`, the `core.sshCommand` override, optional identity, and Git
config isolation. They also unset inherited credential and repository overrides
(including `SSH_AUTH_SOCK`, `SSH_ASKPASS`, `GIT_ASKPASS`, `GIT_CONFIG_PARAMETERS`,
`GIT_DIR`, and numbered `GIT_CONFIG_KEY_*`/`GIT_CONFIG_VALUE_*` entries) so the
session uses only the explicit temporary key. `shell` without a path only isolates
history; create and export inside it.

Git config isolation uses `GIT_CONFIG_GLOBAL` and `GIT_CONFIG_SYSTEM`, which
require Git 2.32 or newer. On older Git, use `--no-isolate-config`; the explicit
`GIT_SSH_COMMAND` still works.

`start` and `shell` print a short next-steps banner, including the
revoke-before-cleanup reminder.

The parent shell records only `start` or `shell`; neither contains a secret. `create`
run inside the isolated shell is also isolated. If the tool detects an existing
isolated shell, `shell` does nothing and `start` refuses and points at `create`; do
not nest; use `create` then `env` inside the existing shell.

The child skips user startup files and sends history to `/dev/null`. Run all key,
git, and cleanup commands inside it. It does not load aliases; `PATH` is inherited.
Environment changes do not carry back to the parent. End with `exit`.

This is required by this skill on every run, not only when history is audited. This
is shell-history isolation; it is separate from the Git config isolation that
`start` and `env` apply, which ignores global/system Git config and is on by default.

- The child's in-memory history disappears on exit; the parent's history is not
  rewritten. The shell-entry command may remain in the parent's history (no
  credentials).
- This is prevention, not retroactive deletion. If commands were already recorded,
  there is no portable, reliable way to erase only one session; zsh `SHARE_HISTORY`
  can interleave terminals. Do not truncate `HISTFILE`, run blanket clears, or delete
  entries by an unreviewed pattern.
- It does not erase scrollback, agent transcripts, audit logs, backups, or remote
  logs. Do not claim complete erasure.

## Cleanup guards

- `cleanup [dir]` prints literal `rm -i` paths and `rmdir`; it deletes nothing.
  When `dir` is omitted, it uses `$KEY_DIR`, which `start`, `shell KEY_DIR`, and
  `env` export.
- `--remove` requires interactive terminals on stdin and stderr. It prompts per
  managed file on stderr, then removes the directory without recursion. stdout may
  be captured. A failed prompt write aborts before deleting anything.
- It refuses a directory that is not absolute, is a symlink, is not owned by the
  user, is not mode 700, whose basename is not `temp-ssh-key.*`, or that contains
  anything other than `id_ed25519`, `id_ed25519.pub`, and `public-key.png`.
- It never uses recursive or forced deletion. If deletion is declined or files
  remain, report incomplete cleanup and leave them.
- Never discover targets by globbing temporary directories, using a stale variable,
  or including keys from earlier sessions.
- If the key was independently added to an agent, remove only that identity; never
  clear the whole agent.
- Deleting local files does not revoke remote authorization; deleting the remote key
  is the revocation step. Do not promise secure erasure on SSDs.

## Command surface

```text
create [--format text|qr|png] [--comment TEXT] [--allow-unencrypted] [--base DIR]
shell  [KEY_DIR] [--shell zsh|bash]
start  [--format text|qr|png] [--comment TEXT] [--allow-unencrypted] [--base DIR]
       [--shell zsh|bash] [--name NAME --email EMAIL] [--no-isolate-config]
show   KEY_DIR [--format text|qr|png]
env    KEY_DIR [--name NAME --email EMAIL] [--no-isolate-config]
cleanup [KEY_DIR] [--remove]
```

`--help` is authoritative. `create` no longer enters a shell; `start` composes
create and shell. `--allow-unencrypted` only after explicit agreement. `--comment`
must not be an email unless requested. `--base` must be an approved temporary
location, never a repository or synced folder.

## Troubleshooting

- `temp-ssh-key: command not found`: install it; do not assume the skill directory
  contains the executable.
- Version older than `0.2.3`: upgrade before running the flow.
- `create` refuses: stdin is not a terminal (needed for a passphrase) or stderr is
  not a terminal (needed for QR output). Run it in the user's terminal; use
  `--format png` or `text` if QR rendering is impossible. Versions before `0.1.3`
  wrongly checked stdout and rejected the documented
  `eval "$(temp-ssh-key create --format qr)"` flow; upgrade instead of working
  around it.
- `show --format qr` refuses: stdout is not a terminal (for example, it is piped).
- `show`, `env`, or `shell` rejects the key pair: the private key is missing or
  unreadable, or its embedded public half does not match `id_ed25519.pub`. Do not
  reuse the directory; report it and create a fresh key.
- `start` says it is already in an isolated shell: run `create` then `env` there.
- `env: no such key directory` or missing `$KEY_DIR`: the variable is unset or the
  directory was removed. Do not guess a path; rerun the flow.
- `cleanup` says `KEY_DIR is not set`: run it inside the session started by `start`
  or `shell KEY_DIR`, or pass the path explicitly.
- `cleanup --remove` refuses: stdin or stderr is not an interactive terminal. Run it
  in the user's terminal; stdout may still be captured.
- Git commits fail with no identity: `start` isolates global config by default, so
  pass `--name` and `--email` (or use `--no-isolate-config`, or set the identity in
  the repository).
- Wrong account greeted: stop; do not push.
- Push URL unexpectedly uses an internal host: an `insteadOf` or `pushInsteadOf`
  rule is active; inspect with the commands above and use an explicit personal SSH
  URL. `env` ignores global/system config by default; if `--no-isolate-config` was
  used, drop it.
- QR will not scan: enlarge the terminal, increase contrast, or use `--format png`.
- `cleanup` refuses: unexpected files or a changed/symlinked directory; do not force
  it; inspect and report.
