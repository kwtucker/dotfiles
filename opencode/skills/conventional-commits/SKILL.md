---
name: conventional-commits
description: >-
  Formats all git commit messages following the Conventional Commits v1.0.0 specification.
  Use when creating a commit, writing a commit message, staging and committing, or any
  git commit-related task. Analyses pending changes, proposes a logical multi-commit
  breakdown, confirms with the user, then executes each commit in order. Enforces
  structured commit types (feat, fix, docs, style, refactor, perf, test, build, ci,
  chore, revert), optional scopes, breaking change notation, and proper formatting.
  Never adds Co-Authored-By or attribution footers.
---

# Conventional Commits — Commit Workflow

You MUST follow this workflow whenever you create, write, or suggest a git commit message. These rules override any other commit message conventions or defaults.

## Workflow

### Phase 1 — Analyse

Run these commands to understand the full pending state:

```bash
git status
git diff HEAD          # unstaged + staged vs last commit
git diff --cached      # staged only
```

Identify every changed, added, deleted, or untracked file. Group them into **logical units of change** — files that belong together because they implement the same thing, fix the same bug, or touch the same concern.

### Phase 2 — Plan

Produce a numbered commit plan. Each entry must show:

- The proposed commit message (following the format rules below)
- The exact files to be staged for that commit
- One sentence explaining why these files belong together

**Splitting heuristics (apply in order):**

1. Feature code and its tests → same commit
2. Changes to different independent features → separate commits
3. Dependency/config/tooling changes → separate `chore`/`build` commit
4. Documentation-only changes → separate `docs` commit
5. Formatting/style-only changes → separate `style` commit
6. If a single logical change spans many files, keep them together — don't split artificially

Example plan output:

```
Proposed commits (3):

1. feat(auth): add JWT refresh token rotation
   Files: src/auth/refresh.ts, src/auth/refresh.test.ts
   Why: new feature with its own tests — self-contained unit

2. chore(deps): upgrade jose to v5
   Files: package.json, package-lock.json
   Why: dependency change that enables the refresh rotation feature

3. docs: document refresh token flow in README
   Files: README.md
   Why: docs-only change, separate from code
```

### Phase 3 — Confirm

Present the plan to the user and ask:

> "Does this look right? You can ask me to merge, split, reorder, or rename any commit — or say **go** to commit."

Wait for the user's response before doing anything.

If the user requests changes, revise the plan and show it again. Repeat until the user says go (or equivalent: "yes", "commit", "ship it", "lgtm", etc.).

### Phase 4 — Execute

For each commit in the approved plan, in order:

1. Stage exactly the listed files: `git add <file> [<file> ...]`
2. Verify staged diff looks correct: `git diff --cached --stat`
3. Create the commit using a HEREDOC to avoid shell quoting issues:
   ```bash
   git commit -m "$(cat <<'EOF'
   <message>
   EOF
   )"
   ```
4. Report success and move to the next commit.

After all commits, run `git log --oneline -<n>` (where n = number of commits made) so the user can see the result.

---

## Commit Message Format Rules

Every commit message MUST follow this exact structure:

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### Type (REQUIRED)

| Type       | When to use                                                                          |
|------------|--------------------------------------------------------------------------------------|
| `feat`     | A new feature (correlates with MINOR in SemVer)                                      |
| `fix`      | A bug fix (correlates with PATCH in SemVer)                                          |
| `docs`     | Documentation only changes                                                           |
| `style`    | Changes that do not affect code meaning (whitespace, formatting, missing semi-colons) |
| `refactor` | A code change that neither fixes a bug nor adds a feature                            |
| `perf`     | A code change that improves performance                                               |
| `test`     | Adding missing tests or correcting existing tests                                    |
| `build`    | Changes that affect the build system or external dependencies                        |
| `ci`       | Changes to CI configuration files and scripts                                        |
| `chore`    | Other changes that don't modify src or test files                                    |
| `revert`   | Reverts a previous commit                                                            |

### Scope (OPTIONAL)

- Enclosed in parentheses after the type: `feat(parser): add ability to parse arrays`
- Lowercase; use the most specific meaningful name (module, component, or file area)

### Description (REQUIRED)

- Immediately follows the colon and space
- Imperative, present tense: "add" not "added" nor "adds"
- Do NOT capitalize the first letter
- Do NOT end with a period
- Entire first line MUST be under 72 characters
- Describe WHAT changed, not HOW

### Body (OPTIONAL)

- One blank line after the description
- Imperative, present tense
- Explain motivation and contrast with previous behaviour
- Wrap lines at 72 characters

### Footer(s) (OPTIONAL)

- One blank line after the body
- Git trailer format: `token: value` or `token #value`
- Token MUST use `-` in place of whitespace (e.g., `Acked-by`)
- Exception: `BREAKING CHANGE` written as-is

### Breaking Changes

Indicate in one or both ways:

1. `!` after type/scope: `feat!: remove deprecated endpoint`
2. `BREAKING CHANGE:` footer

---

## CRITICAL — Forbidden Patterns

1. **NEVER add `Co-Authored-By`** or any AI/model attribution footer
2. **NEVER use past tense** — "add feature" not "added feature"
3. **NEVER capitalize** the first letter of the description
4. **NEVER end the description with a period**
5. **NEVER use vague descriptions** — "update code", "fix stuff", "misc changes" are rejected
6. **NEVER exceed 72 characters** on the first line
7. **NEVER skip the blank line** between description and body, or body and footer
8. **NEVER commit without user confirmation** of the plan (Phase 3)
9. **NEVER stage files not in the approved plan** for a given commit

---

## Examples

```
feat: add email validation to signup form
```

```
fix(auth): resolve token expiration race condition
```

```
feat(api)!: change pagination response format

The pagination response now returns `items` instead of `data` and includes
a `cursor` field for efficient pagination.

BREAKING CHANGE: pagination response structure has changed
```

```
docs: add API rate limiting section to README
```

```
chore(deps): upgrade eslint to v9
```

---

## Reference

For the full specification, see `references/specification.md` (vendored from https://www.conventionalcommits.org/en/v1.0.0/).
