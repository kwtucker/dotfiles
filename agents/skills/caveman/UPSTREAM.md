# Upstream source for caveman skill

- Repository: https://github.com/JuliusBrussee/caveman
- Upstream path: `skills/caveman/SKILL.md`
- Upstream commit: `2e068f735253cce28256744804785f01887d9646`
- Vendored at: 2026-11-03
- License: Apache-2.0; upstream's retained MIT notice is included in `LICENSE-MIT`.
- Vendored files:
  - `SKILL.md`: adapted as described below.
  - `LICENSE` and `LICENSE-MIT`: verbatim from the repository root at this commit.
  - `NOTICE`: the applicable copyright and retained-MIT notices from upstream's
    root notice; notices for runtime components not included here are omitted.

## Local adaptations

- Narrowed the description to explicit user invocation rather than broad triggers
  such as "be brief" or "less tokens".
- Added `disable-model-invocation: true` for manual-only use in OpenCode V2 and
  Copilot CLI, explicit `user-invocable: true`, and license metadata.
- Added a modification notice and an Activation section: inspecting the skill
  does not activate it, and host instructions and required reporting still apply.
- Removed the `ultracave` / `megacave` aliases and the `caveman-compress` exception
  because those companion skills are not included.
- Kept upstream's response rules and conversational status behavior otherwise
  unchanged. No hooks, automatic activation, proxy, CLI, or model routing is
  installed. Mode persistence is an instruction, not durable host-managed state.

## Upgrading

Updates are manual; `make -C agents sync-skills` updates only the commit skill.

1. Choose and record a new full upstream commit SHA, not a moving branch URL.
2. Fetch `skills/caveman/SKILL.md`, `LICENSE`, `LICENSE-MIT`, `NOTICE`, and
   `LICENSING.md` from that commit. Review changes and applicable notices before
   replacing the vendored files.
3. Reapply the local adaptations above, retaining manual-only activation and the
   modification notice. Update this file's SHA and date.
4. Parse the frontmatter, review the diff, and run `git diff --check`. Validate
   installation, repeat installation, conflict rejection, and owned-link cleanup
   with temporary HOME/XDG directories outside this checkout.
5. After installing with `make agents`, check manual invocation in OpenCode V2
   with `@caveman` and Copilot CLI with `/caveman`. Generic brevity requests must
   not activate it. Verify status, deactivation, exact technical payloads, and
   normal prose for persisted writing and safety warnings. These behavior checks
   require model sessions; installation checks alone do not establish them.

Upstream licensing details:
https://github.com/JuliusBrussee/caveman/blob/2e068f735253cce28256744804785f01887d9646/LICENSING.md
