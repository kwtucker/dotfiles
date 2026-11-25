# Shared agent guidance

Portable engineering instructions and skills used by OpenCode and Copilot.
This module configures discovery; it does not install a model provider or prove
that generated code is correct.

## How-to install and verify discovery

From the dotfiles root, run `make agents`, or use `make opencode` / `make copilot`
to install shared guidance before the client configuration. Provision the
client's tools separately through the selected profile.

Follow [EVALUATION.md](EVALUATION.md) to check instruction/skill discovery in a
fresh client session and evaluate representative tasks. Model calls can incur
cost; obtain permission before running evaluations.

To refresh the vendored commit skill deliberately:

```sh
make -C agents sync-skills SKILL_SYNC_ARGS="--sha REPLACE_WITH_COMMIT"
```

Review upstream changes and licensing before applying them. This changes
tracked skill files; it is not a discovery check.

## Reference

| Source | Installed destination |
| --- | --- |
| `instructions/engineering.md` | `~/.agents/instructions/engineering.md` |
| `skills/conventional-commits` | `~/.agents/skills/conventional-commits` |
| `skills/go-development` | `~/.agents/skills/go-development` |
| `skills/caveman` | `~/.agents/skills/caveman` |

`make agents.clean` removes only the exact managed links. It preserves the
parent directory and other tools' skills. Read the [Makefile](Makefile) for the
authoritative link list.

## Explanation

Shared behavior lives here once; client-specific config stays in the client
module. Detailed Go references are loaded on demand instead of expanding every
session's global context. Repository `AGENTS.md` is checkout guidance, not the
global instruction file. Existing skills and policies remain operational assets.
