---
name: temporary-ssh-key
description: Generate a temporary Ed25519 SSH key pair and share only its OpenSSH public key as text, a terminal QR code, or a PNG for manual authorization on another server or GitHub. Keep private keys outside the repository, preserve existing SSH configuration, and explain one-time use and cleanup.
---

# Temporary SSH key

Create a disposable authentication key for the current machine. Display the
public key so the user can authorize it elsewhere; never transfer the private key.
Loading or installing this skill alone does not authorize key generation.

## 1. Confirm scope and passphrase handling

- Respect plan/read-only mode. Generate keys only when the user requests it and
  writes are permitted.
- Identify whether the destination is an SSH server or a service such as GitHub.
  Do not contact or change the destination without separate authorization.
- Default to a passphrase entered by the user in an interactive terminal. Never
  ask for a passphrase in chat, capture it in tool output, or put it in arguments,
  environment variables, files, or shell history.
- If the available tool cannot provide a user-controlled interactive terminal,
  create the private directory, provide the exact generation command for the
  user's terminal, and wait for confirmation before reading the public key.
- An unencrypted key is permitted only after the user explicitly agrees to that
  tradeoff. Only then may generation use `-N ''`; never silently default to it.

### GitHub commit-email reminder

For GitHub workflows, remind the user: **before making personal commits, check
your email in Git's `config.local`; switch it to your personal email if needed,
and switch it back when finished.** SSH authentication and commit authorship are
separate; changing keys does not change the email recorded in a commit. Pushing
existing commits alone does not require changing the email.

- Confirm the included local config path instead of assuming it. In this dotfiles
  setup it is normally `~/.config/git/config.local`; other installations may use
  `${XDG_CONFIG_HOME:-$HOME/.config}/git/config.local`. Never edit a tracked example
  or put personal/work addresses into this skill.
- Before a temporary change, have the user privately record the file's existing
  `user.email` setting, including whether it was absent or had multiple values.
  Preserve unrelated settings; do not dump the full config, which may contain
  credentials. Do not edit the file without separate authorization.
- Provide a command targeting that exact file, with the user's chosen personal
  email, if they want to switch it. Verify the effective author and committer in
  the intended repository before committing:

  ```sh
  git var GIT_AUTHOR_IDENT
  git var GIT_COMMITTER_IDENT
  ```

- Repository-local config or environment variables can override `config.local`.
  If the effective email is wrong, investigate its source rather than assuming
  the file change worked. Do not rewrite existing commits automatically.
- Keep restoration on the cleanup checklist even if key generation or
  authentication fails. Restore the exact previous setting, not a guessed work
  address. If it was originally absent, remove only the setting introduced by
  this workflow rather than adding a new permanent default.

### Optional terminal-history isolation

If the user wants to keep this workflow out of terminal history, offer a separate
history-isolated shell **before** they run any key commands. Check their shell;
do not apply Bash history commands to zsh or assume the agent's tool shell is the
user's interactive terminal.

For zsh, have the user run this in their terminal:

```sh
env HISTFILE=/dev/null SAVEHIST=0 zsh -f
```

This starts a child shell without user startup files and directs its history to
`/dev/null`. Run the temporary-key commands inside that shell. It intentionally
does not load the user's aliases or other interactive customizations. Environment
changes and shell variables in the child do not carry back to the parent.

After restoring any temporary commit-email change and revoking/deleting the key,
provide the session-ending command:

```sh
exit
```

The child shell's in-memory history goes away when it exits, without rewriting
the parent's history file. The launcher itself may remain in the parent's history;
it contains no credentials. This is prevention, not retroactive history deletion.

If commands were already recorded, explain that there is no portable, reliable
command to erase only one session from shared history. In particular, zsh's
`SHARE_HISTORY` can interleave commands from multiple terminals. Do not truncate
`HISTFILE`, run blanket history-clear commands, or delete entries by an unreviewed
pattern. Targeted retroactive cleanup requires inspecting the actual user's shell
settings and agreeing on specific entries first; a subprocess cannot directly
clear the parent terminal's in-memory history.

Neither this shell nor history cleanup erases terminal scrollback, agent
transcripts, audit logs, backups, or remote logs. Do not disable security controls
or claim complete erasure. Passphrases must still be entered only at hidden
interactive prompts, never in command text.

## 2. Generate outside the checkout

- Check that `ssh-keygen` is available. Do not install tools automatically.
- Use `mktemp -d` in the environment's approved temporary location, otherwise the
  platform's temporary directory. Set `umask 077`; ensure the directory is private
  (mode 700). Never put credentials inside a repository or a synced folder.
- Record the returned absolute directory path. Shell variables do not necessarily
  persist across tool calls; use the actual path in subsequent commands.
- Use fresh filenames `id_ed25519` and `id_ed25519.pub`. Refuse to overwrite any
  existing file or link, including a dangling symlink.
- Generate the key with a generic comment, not an email address. Substitute the
  actual private directory in this command:

  ```sh
  ssh-keygen -t ed25519 -C "temporary-ssh-access" -f "/absolute/key-directory/id_ed25519"
  ```

- Let the user enter and confirm the passphrase interactively. Do not run a
  command that will wait for input in a noninteractive tool.
- After successful generation, verify the private key is a regular, non-symlink
  file with mode 600. Verify the public key is a regular, non-symlink file and
  parses as an Ed25519 key with `ssh-keygen -lf`.
- Never read, print, upload, commit, or copy the private key into chat. Do not add
  it to an SSH agent or edit SSH/Git configuration automatically.

## 3. Share the public key

Offer **public-key text**, **terminal QR**, or **PNG**. Default to text if the
user has no preference. Every format must use the verified `.pub` file only;
never encode the private key or use an external QR-generation service.

### Public-key text

Use `cat` on the verified `.pub` file:

```sh
cat "/absolute/key-directory/id_ed25519.pub"
```

Show the complete public key as one copyable line, without truncation. It should
start with `ssh-ed25519`, followed by the encoded key and optional comment.

### QR output

Check whether `qrencode` is available on PATH with `command -v qrencode`. If it is
missing, explain that QR output is unavailable and fall back to public-key text.
Do not install packages automatically. If QR generation fails, report the failure
and provide text instead; do not claim a QR artifact was created successfully.

For a terminal QR code:

```sh
qrencode -t ANSIUTF8 < "/absolute/key-directory/id_ed25519.pub"
```

This must run in a terminal the user can see. Tool output or Markdown renderers
may not preserve ANSI colors or QR alignment; in that case, provide the exact
command for the user's terminal or offer PNG/text instead. Do not claim that
captured ANSI output is a usable rendered QR code.

For PNG, refuse to overwrite any existing file or link, including a dangling
symlink, at the output path. Generate inside the private temporary key directory:

```sh
qrencode -t PNG -o "/absolute/key-directory/public-key.png" < "/absolute/key-directory/id_ed25519.pub"
```

Verify successful creation of a nonempty PNG before reporting its path. Keep track
of this generated file for cleanup. Do not open it in a browser, upload it, or copy
it outside the temporary directory automatically.

Explain that the QR code contains the actual public-key text, not a hosted link.
The receiving device needs a scanner that supports plain text. Scanning transfers
text only; it does not authorize the key. After scanning, verify that the complete
decoded text starts with `ssh-ed25519` and was not truncated or wrapped into multiple
lines when pasted. For stronger verification, compare the original public-key
fingerprint with the decoded key saved on the destination, using `ssh-keygen -lf`
on both files. Do not claim a scan/round-trip verification was performed unless
it actually was.

### Destination instructions

For every format, report the private key's local path, but never its contents.

Explain where the public key belongs:

- **SSH server:** the destination user's `~/.ssh/authorized_keys`, not
  `~/.ssh/config`. It is one authorized key per line; preserve existing entries.
- **GitHub:** the intended account's **Settings → SSH and GPG keys → New SSH key**,
  with key type **Authentication Key**. Give it a recognizable temporary title.

Do not install the key remotely or overwrite `authorized_keys` on the user's behalf
unless separately requested.

## 4. Explain one-time use

Provide a command using the actual local private-key path and the user's intended
destination, or clearly labeled placeholders if the destination is unknown:

```sh
ssh -o IdentitiesOnly=yes -i "/absolute/key-directory/id_ed25519" user@host
```

Keep host-key verification enabled. Existing SSH configuration may supply other
identity files or required connection settings; investigate those only if needed,
without persistently changing work authentication. Do not claim authentication
succeeded unless an authorized connection test actually succeeded.

### GitHub: include authentication and push commands

For GitHub workflows, always provide both the authentication check and the actual
one-time push command; do not stop at key registration or the SSH test. Substitute
the actual generated private-key path, intended repository, and branch. Inspect
the push remote and current branch when available instead of assuming `origin`
and `main`; ask if the intended target is ambiguous. Use clearly labeled
placeholders when the target is unknown.

For a direct GitHub connection, isolate the temporary key from work SSH settings:

```sh
ssh -F /dev/null -o IdentitiesOnly=yes -i "/absolute/key-directory/id_ed25519" -T git@github.com
```

Explain that success should greet the intended GitHub username, and GitHub's SSH
test normally exits with status 1 even after successful authentication. If it
greets the wrong account, stop before pushing. `-F /dev/null` bypasses SSH config;
if a required proxy or other connection setting is needed, investigate and adapt
the one-time command rather than changing persistent configuration.

If the confirmed push remote uses SSH, provide this command with the actual
remote and branch substituted for `REMOTE` and `BRANCH`:

```sh
git -c core.sshCommand="ssh -F /dev/null -o IdentitiesOnly=yes -i '/absolute/key-directory/id_ed25519'" \
  push REMOTE BRANCH
```

Quote the actual key path safely for both shell-parsing layers. If the remote
uses HTTPS, `core.sshCommand` alone will not switch its transport; instead provide
an explicit SSH destination such as `git@github.com:OWNER/REPOSITORY.git`, after
confirming the target. Neither approach should change saved remotes or config.
Never add `--force` or disable host-key verification. Providing the command does
not authorize the agent to execute a push; do so only when separately requested.

Remind the user to enter the key passphrase at the hidden prompt, and include
the cleanup reminders after the push instructions: revoke the GitHub key, remove
the generated local files, and restore any temporary `config.local` email change.

Temporary directories may be removed by the operating system. This key is for
short-lived use, not durable access or recovery.

## 5. Provide session-specific cleanup; do not perform it automatically

Finish by providing a copyable cleanup checklist and commands with the actual
absolute paths generated in this session, not just generic cleanup advice. Track
the key directory, public-key fingerprint, and any PNG created by this workflow.
Do not discover deletion targets by globbing temporary directories, using a
possibly stale shell variable, or including keys from earlier sessions.

### Revoke remote authorization first

- For GitHub, direct the user to **Settings → SSH and GPG keys** and identify the
  temporary key by its title and recorded public-key fingerprint. For an SSH
  server, remove only this public-key entry from the destination user's
  `authorized_keys`. Preserve all other keys.
- Ask the user to confirm remote revocation before proceeding with local
  deletion. Do not claim revocation happened merely because commands were shown
  or local files were removed. If revocation cannot be completed, clearly report
  that remote authorization remains; do not silently mark cleanup complete.
- If the user independently added this key to an SSH agent, explain how to remove
  only this identity while its public-key file is still available. Never clear
  the entire agent or assume the workflow added the key.

### Remove only the generated local files

After the user confirms they are finished and remote authorization was revoked,
provide commands like these, substituting the recorded absolute directory:

```sh
rm -i \
  "/absolute/key-directory/id_ed25519" \
  "/absolute/key-directory/id_ed25519.pub"
rmdir "/absolute/key-directory"
```

Add the exact `public-key.png` path to the `rm -i` arguments only if this workflow
created it. Do not include an unrelated existing image. Explain that `rm -i`
prompts before each deletion and must be run in the user's interactive terminal,
not an agent tool that cannot accept their responses. Providing these commands
does not authorize the agent to execute them.

Use literal, safely quoted paths; refuse cleanup if the directory has been
replaced by a symlink or its identity is uncertain. `rmdir` must refuse to remove
a nonempty directory. If deletion is declined or unexpected files remain, leave
them intact, report incomplete cleanup, and do not retry with recursive or forced
deletion. Never delete earlier temporary-key directories or unrelated SSH files.
QR images and copied public-key text on other devices are not removed locally.

### Restore commit identity and end the isolated shell

If `config.local` was temporarily changed for personal commits, remind the user to
**switch the email back to its exact previous setting**, preserving other changes.
Verify the effective author/committer in the repository where they will resume
work:

```sh
git var GIT_AUTHOR_IDENT
git var GIT_COMMITTER_IDENT
```

Exiting the history-isolated shell does not undo edits to `config.local`. After
restoration and key cleanup, if this workflow set `KEY_DIR` and the user is still
inside the isolated child shell, provide:

```sh
unset KEY_DIR
exit
```

If no variable was set, omit `unset KEY_DIR`. If the user did not start an isolated
child shell, omit `exit`; do not inadvertently close their normal terminal. This
ends the isolated session without clearing unrelated shared history, but does not
erase terminal scrollback or agent transcripts.

Deleting the local files does not revoke the remote authorization. Do not promise
secure erasure on SSDs; removing the remote authorization is the revocation step.
