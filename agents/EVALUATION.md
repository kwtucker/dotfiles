# Evaluate the Go agent setup

Instruction discovery can be checked; consistently better generated code still
needs evaluation on representative tasks. Do not equate installation checks with
LLM quality evaluation, or a model's self-assessment with independent verification.
Keep any validation scripts, test fixtures, and scratch modules temporary and
outside this dotfiles checkout; remove them afterward. Do not add a test suite here.

## Discovery smoke check

- Install with `make copilot` (or `make agents` for shared guidance only).
- Start a fresh Copilot CLI session and inspect `/instructions` and `/skills list`.
  Confirm `engineering.instructions.md`, any existing personal instructions, and
  `go-development` appear. Do not load all Go references at startup.
- In OpenCode, confirm the global configuration's `instructions` entry resolves
  and `go-development` is advertised. Ask it to identify its instruction sources
  and load the skill; do not infer discovery just from a plausible Go answer.
- In Desktop, inspect **Customize → Skills/MCP**. CLI skill and MCP discovery is
  documented; verify instruction behavior in the installed app rather than assuming
  every CLI preference or instruction source applies to Desktop.

## Representative task evaluation

Use a disposable checkout or a scratch Go module, never a production environment.
Obtain permission before running model sessions or tools that incur cost. Keep task
prompts and acceptance tests fixed; use equivalent fresh sessions and environments
for comparisons. Repeat tasks because a single output is noisy. Example tasks:

| Task | Required evidence |
| --- | --- |
| Fix a boundary-condition bug | Regression test fails before the fix, passes after; no unrelated changes |
| Refactor a cross-package API | Callers identified and updated; relevant package/dependent tests pass |
| Fix cancellation/shutdown | Deterministic lifecycle tests and appropriate race checks; no leaked work |
| Integrate a versioned API | Actual installed API consulted; successful and failing paths tested |
| Explain a small Go function | Accurate, focused explanation; no source edits or unnecessary full scans |
| Edit non-Go configuration | No unnecessary Go skill load or Go tool/scan calls |

Review correctness and hidden edge cases independently; model-written tests can
repeat the model's misunderstanding. Check compatibility, error behavior, cleanup,
test independence, and public API impact, not just whether the visible suite passes.

Record model/version, reasoning setting, task, correctness, missing checks, review
effort, unrelated edits, latency, and available token/tool-call cost. Require honest
reporting of validation and blocked checks. Use deeper reasoning where it improves
results, especially API design/concurrency; do not force maximum effort on every edit.

Keep a tool or instruction only if it improves these outcomes. Add specialized
skills/MCP servers only for demonstrated gaps. Avoid automatic multi-agent
orchestration or a larger always-on prompt as a substitute for measured improvement.
