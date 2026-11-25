# Resolve conflicts and recover configuration

Use this guide when a module refuses an existing destination, or you need to
restore an adoption backup. It is not whole-machine rollback.

## Inspect the conflict

From the checkout root:

```sh
scripts/state check-links --preflight
make status
```

Inspect each reported file, directory, or link before replacing it. The shared
link helper refuses unmanaged destinations by default. Links into this checkout
can be repaired without backup; sockets, pipes, and devices are always refused.
Preflight covers modeled links, not every side effect of an installation.

## Adopt one destination deliberately

For example, after reviewing the existing Bat configuration directory:

```sh
DOTFILES_ADOPT=1 make bat
```

The helper moves conflicts into
`${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles/backups/<timestamp>/`, preserves
HOME-relative paths, and records each move in `manifest.tsv`. For a reviewed
full update, `DOTFILES_ADOPT=1 ./install` uses the same mechanism for module
links. The global mise config force-link is an exception; back it up yourself.

## Restore an adopted path

Find the backup run and inspect its manifest. For a Bat directory, first verify
that the current `~/.config/bat` is the managed symlink you intend to remove.
Then replace **that symlink only**, not the directory it points to:

```sh
backup="$HOME/.local/state/dotfiles/backups/REPLACE_WITH_TIMESTAMP"
unlink "$HOME/.config/bat"
mv "$backup/.config/bat" "$HOME/.config/bat"
```

Adjust paths when XDG directories differ. The restored path becomes a conflict
again on the next install; this is intentional. Do not run broad recursive
deletes as a recovery shortcut.

## Return to an older revision

Save pending changes first. Inspect the desired revision and affected module
recipes before switching. `git switch --detach REVISION` changes the checkout;
it does not downgrade installed tools or restore deleted data. Since installed
config is symlinked, applications can observe checkout changes immediately.

Apply the chosen revision deliberately, using its own documented install and
tool workflow. Be aware that `./install` can clean profile changes and prune
tools even when detached. Returning to `main` may resume upstream pulling on
later installs. Backups and revision changes cannot recover missing secrets,
passphrases, unrelated files, or plugin/editor state that was never backed up.
