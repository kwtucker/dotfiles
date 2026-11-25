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

## 3. Write idiomatic, focused Go

Follow established repository conventions over these defaults. Do not rewrite
unrelated code solely to enforce them.

### Design

- Choose the simplest implementation that fully meets the requirements. Start
  with direct code and existing patterns. Add helpers, abstraction layers, or
  configuration only when they solve a concrete problem or make the code easier
  to read. Don't build for hypothetical needs or trade correctness for fewer
  lines.
- Before adding state, recovery, or edge-case paths, confirm that a real caller
  or requirement needs them. Otherwise choose the simplest safe behavior, such as
  failing and resetting.
- Search for an existing helper before writing one. When several call sites
  repeat the same steps, such as parse, bounds check, and format, consolidate
  them into one helper.
- Use cohesive packages, useful zero values, and small APIs. Introduce
  interfaces at real consumer boundaries, not automatically for mocking. Accept
  interfaces and return concrete types. Use generics only when they simplify an
  actual shared operation.
- Avoid package-level mutable state and `init()` side effects; inject
  dependencies instead.
- Make ownership and cleanup explicit, including meaningful close/flush errors.
  Preserve nil-versus-empty and other observable behavior when it is contractual.

### Control flow and invariants

- Prefer early returns and a clear happy path. Avoid `else` after an exiting
  branch (`return`, `continue`, `break`, `goto`, or `panic`), but preserve
  evaluation order, exclusivity, side effects, and cleanup. When neither branch
  exits, `if`/`else` is correct; do not contort it. Keep a conditional or
  `switch` when flattening would make the logic less clear.
- Enforce invariants where they are relied on. Do not index or dereference on the
  strength of a caller precondition, such as a possible `-1` from `slices.Index`;
  return `ok` or an error instead.

### Names and signatures

- Name functions for what they validate or return, not for where they are used.
- Avoid repeating the package name (`http.Server`, not `http.HTTPServer`), keep
  initialisms in one case (`UUID`, `userID`), and omit `Get` from getters.
- Use short receiver names consistently, and do not mix pointer and value
  receivers on one type.
- Pass `context.Context` as the first parameter; do not store a context in a
  struct. Storing a context factory or a cancel function owned by the struct is
  fine.
- Avoid bare `bool` parameters whose meaning is unclear at the call site, such as
  `refresh(id, live, true)`. Prefer separate functions or a named type unless an
  interface you implement fixes the signature.
- Return `(T, bool)` for simple absence or validity, and `error` when callers
  need the reason.
- Use named results sparingly: for documentation or when a deferred function
  must change the returned error. Avoid naked returns in non-trivial functions.

### Errors

- Handle every error explicitly. Never discard one with `_` without a comment
  explaining why. Do not panic for expected recoverable failures.
- Return zero values with a non-nil error, never a partly filled result.
- Add useful context, and avoid duplicate log-and-return handling.
- Wrap deliberately: use `%w` only when callers should match the cause with
  `errors.Is` or `errors.As`, and `%v` to hide it. Wrapping also exposes the
  cause to status inspection, which can change how callers classify the error.
- Write error strings in lowercase without trailing punctuation, since callers
  wrap them.

### Dependencies

- Prefer existing dependencies and standard-library facilities, including
  `slices`, `maps`, `clear`, `min`/`max`, and range-over-int where the module's
  Go version allows.
- Do not run broad `go mod tidy`, upgrade dependencies, or raise the minimum Go
  version as incidental cleanup. Inspect intentional module-file changes.

### Formatting and layout

- Follow repository formatting first. Otherwise run `goimports -w` followed by
  `gofumpt -w` on explicit changed Go files when available. If unavailable, use
  repository tooling or `gofmt` and disclose the fallback. Check that automatic
  import selection chose the intended package; avoid unrelated formatting.
- Go sets no line limit; do not split lines to meet a column count. When a line
  is hard to read, first shorten it with better names or an extracted variable
  or helper. Otherwise split at semantic boundaries, not by length. Once a
  signature, call, or composite literal is split, put one item per line.
- Go does not mandate declaration order. In new or substantially revised files,
  prefer constants and supporting types, then the main operation or API, then
  helpers in call-flow order, with decoding and validation before lower-level
  lookup and control helpers. The goal is a main flow that is easy to find.
- Group methods by receiver; never interleave methods of different types. Place
  package-level tables near the logic they support, and preserve initialization
  behavior when moving declarations.

### Comments

- Document exported functions, methods, and types. Begin with the exact symbol
  name in a complete sentence ending with a period. This is the Go convention,
  not a prerequisite for `go doc` or pkg.go.dev rendering.
- Describe the caller-visible purpose and contract, not implementation steps or a
  restatement of the signature. Keep the opening sentence concise; add
  paragraphs only for meaningful constraints, return semantics, side effects,
  concurrency guarantees, or error behavior.
- Document unusual behavior precisely, especially nil results, partial success,
  and unsupported operations. Distinguish errors that wrap a sentinel from
  returning the sentinel directly.
- Comment unexported code only to explain why: invariants, ordering or locking
  requirements, compatibility choices, and rejected alternatives such as "never
  retry this write". Do not narrate what the code does.
- Verify each claim against the implementation. Avoid vague wording or
  guarantees stronger than the implementation provides.

## 4. Validate progressively

- Read only the references the change needs:
  - `references/testing.md` when adding or changing tests or planning validation.
  - `references/concurrency.md` for goroutines, channels, synchronization,
    cancellation, shutdown, or shared mutable state.
  - `references/security.md` for untrusted input, security-sensitive boundaries,
    dependency changes, or a requested security review.
- After a coherent batch of edits, use `go_diagnostics` for changed files when
  available. Resolve relevant diagnostics and run focused package tests.
  Diagnostics are not a substitute for compilation and executable tests.
- During iteration, start with changed packages and affected callers instead of
  repeatedly running entire suites.
- Before completion, use the repository's validation targets. Without a
  prescribed workflow, run affected-module `go test ./...` and `go vet ./...`
  when practical, and `staticcheck` if available. If `golangci-lint` already
  covers equivalent analysis, use its configured workflow instead; still run
  tests. Do not add a tool dependency to module files just to run a check.
- Expand checks according to risk: race tests for concurrency, vulnerability
  checks for dependency or security work, fuzzing for parsers, and benchmarks or
  profiles for performance claims. Honor service, network, runtime, and
  permission constraints.
- If broader checks are impractical or blocked, state exactly what ran and what
  remains unverified. Separate new regressions from baseline failures.

## 5. Review before handing back

Read the full diff and check:

- The approach is the simplest that meets the requirements, with no speculative
  paths and no duplicated helpers.
- Invariants are enforced locally, not assumed from callers.
- Names match their contracts, and `bool` arguments are clear at the call site.
- No `else` follows an exiting branch.
- Errors are wrapped deliberately and none are silently discarded.
- Declarations follow the file layout above.
- Comments still match the code.
- `git diff --check` passes in Git repositories.

Never commit or push unless asked.
