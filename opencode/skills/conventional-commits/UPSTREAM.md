# Upstream source for conventional-commits skill

- Repository: https://github.com/dantuck/claude-kit
- Upstream path: `skills/conventional-commits/`
- Vendored files:
  - `SKILL.md` ← upstream `SKILL.md` (adapted: `name: commit` → `name: conventional-commits`, dropped Claude-only `user-invocable: true`, appended Reference section)
  - `references/specification.md` ← upstream `references/specification.md` (verbatim)
- Vendored at: 2026-09-25
- Upstream commit SHA at vendor time: `9ac80a2b7637d35b10c00825703a4a7b48de16e0` (HEAD of main)

## Upgrading

Run from this dotfiles repo:

```bash
make -C opencode sync-skills
```

Or directly:

```bash
./opencode/skills/conventional-commits/sync.sh
```

The script re-downloads both raw files from `main`, re-applies the OpenCode
adaptations to `SKILL.md`, and prints the new upstream SHA so you can update
the line above. Review the diff with `git diff` before committing.
