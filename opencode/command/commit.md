---
description: Create git commits following Conventional Commits v1.0.0 (plan, confirm, execute)
---

Follow the `conventional-commits` skill workflow to create git commits.

User request / hints: $ARGUMENTS

If no hints were given, analyse all pending changes (`git status`, `git diff HEAD`, `git diff --cached`).

Steps:
1. Group changed files into logical units of change.
2. Propose a numbered commit plan (message + exact files + one-sentence why per commit), following the skill's splitting heuristics and message format rules (type, optional scope, imperative description under 72 chars, no Co-Authored-By footers).
3. Ask the user to confirm — accept merge/split/reorder/rename requests, or "go" (yes, commit, ship it, lgtm) to proceed. Do NOT commit before confirmation.
4. Execute each approved commit in order with `git add <files>` + HEREDOC `git commit -m`, verifying with `git diff --cached --stat`.
5. Finish with `git log --oneline -<n>` showing the new commits.
