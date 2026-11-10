---
name: go-development
description: Write, debug, refactor, test, and review idiomatic Go using repository conventions, gopls, and progressive validation. Use for Go code tasks, Go APIs, modules, dependencies, and concurrency changes.
---

# Go development

Prioritize correct behavior, simple design, and maintainable Go over mechanically
enforcing preferences. Follow the repository's workflow and supported Go version.
Do not treat this skill as authorization to edit in a read-only or planning task.

## 1. Establish the task and build context

- Read applicable repository instructions, nearby code/tests, and configured check
  commands. Identify affected `go.mod` files, any `go.work`, build tags, supported
  platforms, CGO requirements, and generated-code boundaries.
- Use gopls `go_workspace` when starting work in a Go workspace or switching
  projects; refresh context if module/workspace configuration changes. Do not scan
  vulnerabilities merely because a session started. Skip Go tooling outside Go work.
- Respect the module's language version and CI support matrix, not just the local
  compiler. Prefer repository-pinned tools; otherwise use mise-managed tools.
- For a bug, reproduce the problem and add a failing regression test where practical.
  For a feature, identify the observable behavior and compatibility requirements.

## 2. Gather only the context needed

- Use gopls `go_search` for symbols and `go_symbol_references` before renaming,
  changing signatures, or changing contracts with callers. Inspect affected callers.
- Use `go_file_context` when cross-file package dependencies are unclear, and
  `go_package_api` or local `go doc` for package APIs. Read implementations when
  summaries are insufficient. Verify third-party APIs against the project's version.
- Use normal file search for text, configuration, and tests. Do not read the whole
  repository or call every tool for each file. If gopls is unavailable, use local
  search/documentation and compiler/tests, and report the limitation when material.
- MCP is not inherently read-only: `go_rename_symbol` is an editing operation.
  Respect the current task's permissions. Review all tool-suggested edits.

## 3. Implement idiomatic, focused changes

- Prefer early returns and a clear happy path. Avoid `else` after an exiting branch,
  but preserve evaluation order, exclusivity, side effects, and cleanup. Keep a
  conditional or `switch` when flattening would make the logic less clear.
- Use cohesive packages, clear names, useful zero values, and small APIs. Introduce
  interfaces at real consumer boundaries, not automatically for mocking. Use
  generics only when they simplify an actual shared operation.
- Handle errors explicitly. Add useful context and preserve error identity when
  callers need it; use `errors.Is`/`errors.As` appropriately. Avoid duplicate
  log-and-return handling. Do not panic for expected recoverable failures.
- Make ownership and cleanup explicit, including meaningful close/flush errors.
  Preserve nil-versus-empty and other observable behavior when it is contractual.
- Prefer existing dependencies and standard-library facilities when suitable. Do
  not run broad `go mod tidy`, upgrade dependencies, or raise the minimum Go version
  as incidental cleanup. Inspect intentional module-file changes.
- Follow repository formatting first. Otherwise run `goimports -w` followed by
  `gofumpt -w` on explicit changed Go files when available. If unavailable, use
  available repository tooling or `gofmt` and disclose the fallback. Check that
  automatic import selection chose the intended package; avoid unrelated formatting.

### File organization

- Go does not mandate declaration order. For new or substantially revised
  production files, prefer constants and supporting types, then the main
  operation/API, then supporting helpers in call-flow order: decoding/validation
  before lower-level lookup/control helpers, where those phases apply.
- Keep related receiver methods and their types together when that is clearer.
  Place package-level tables near the logic they support, and preserve
  initialization behavior when moving declarations.
- Follow established repository conventions over this default. Do not reorder
  unrelated code solely to enforce it; the goal is to make the main flow easy to
  find and its supporting logic easy to follow.

### Exported API comments

- Document exported functions, methods, and types. Begin the opening sentence with
  the exact symbol name and write a complete sentence ending with a period.
  This is the idiomatic Go convention, not a prerequisite for `go doc` or
  pkg.go.dev to render documentation.
- Describe the caller-visible purpose and contract, not implementation steps or a
  restatement of the signature.
- Keep the opening sentence concise. Add separate paragraphs only for meaningful
  constraints, return semantics, side effects, concurrency guarantees, or error
  behavior.
- Document unusual behavior precisely, especially nil results, partial success,
  and unsupported operations. Distinguish errors that wrap a sentinel from
  returning the sentinel directly.
- Verify each claim against the implementation. Avoid vague wording or guarantees
  stronger than the implementation provides.

## 4. Validate progressively

- Read `references/testing.md` when adding/changing tests or planning validation.
- Read `references/concurrency.md` for goroutines, channels, synchronization,
  cancellation, shutdown, or shared mutable state.
- Read `references/security.md` for untrusted input, security-sensitive boundaries,
  dependency changes, or a requested security review. Do not preload every reference.
- After a coherent batch of Go edits, use `go_diagnostics` for changed files when
  available. Resolve relevant diagnostics and run focused package tests. Diagnostics
  are not a substitute for compilation and executable tests.
- Before completion, use the repository's validation targets. Without a prescribed
  workflow, run affected-module `go test ./...` and `go vet ./...` when practical;
  use `staticcheck` if available. During iteration, start with changed packages and
  affected callers instead of repeatedly running entire suites.
- If `golangci-lint` already covers equivalent analysis, use its configured workflow
  instead of duplicating analyzers; still run tests. Do not add a tool dependency to
  module files just to run a check.
- Expand checks according to risk: race tests for concurrency, vulnerability checks
  for dependency/security work, fuzzing for parsers, and benchmarks/profiles for
  performance claims. Honor service, network, runtime, and permission constraints.
- If broader checks are impractical or blocked, state exactly what ran and what
  remains unverified. Separate new regressions from baseline failures. Review the
  diff and run `git diff --check` in Git repositories. Never commit or push unless asked.
