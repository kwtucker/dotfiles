# Go testing and validation

Use the repository's test framework, build tags, commands, and pinned versions.
Avoid importing a new assertion/mocking framework just for the current task.

## Behavioral coverage

- For a bug, make the regression test fail for the intended reason before the fix
  when practical. Do not weaken existing assertions to obtain a passing suite.
- Cover the behavior changed, relevant boundaries, and failure paths. Prefer
  observable results over coupling tests to private implementation details.
- Use named table-driven subtests when cases share structure. Keep distinct tests
  for unrelated scenarios. Include inputs, expected results, and expected errors.
- Check meaningful error identity/type with `errors.Is`/`errors.As`. Compare exact
  error text only when that text is part of the contract. Failure messages should
  identify inputs, actual results, and expected results.
- Allocate mutable fixtures per case. Use `t.TempDir`, `t.Cleanup`, `httptest`, and
  small fakes at real boundaries. Make cleanup and restoration reliable on failure.
- Do not add `t.Parallel` mechanically: shared process state, environment variables,
  ports, and mutable fixtures can make parallel tests invalid or flaky.
- Prefer explicit synchronization and controllable time over arbitrary sleeps.
  Check version-matched documentation before using newer testing facilities.

## Progressive execution

1. Reproduce the issue or establish the relevant baseline where feasible.
2. During editing, run focused tests, for example
   `go test ./internal/service -run TestRelevantBehavior`. Test packages, not a
   hand-selected list of source files that bypasses package build context.
3. Check callers/dependents for cross-package contracts. Run the broader documented
   unit/integration targets before completion as appropriate to the change.
4. Without repository guidance, use affected-module `go test ./...` and
   `go vet ./...` when practical, plus available `staticcheck`. Run from each
   affected module with the intended workspace, tags, and environment; do not assume
   `./...` at a workspace root covers every module.
5. Use configured `golangci-lint` instead of duplicating equivalent checks. Tests
   and static analysis serve different purposes and neither replaces the other.

Do not start external services, run production-facing integrations, or launch
unbounded expensive suites without the task's authorization. Report unavailable
dependencies and partial validation rather than presenting them as passing.

## Risk-specific checks

- Concurrency: run relevant `go test -race` packages where supported, then broader
  race targets when warranted. A passing race run covers only paths executed.
- Parsers/codecs: add boundary and malformed-input cases; consider a fuzz target
  with useful seeds and bounded fuzz execution. Preserve minimized failures as tests.
- Performance: establish a representative baseline, run comparable benchmarks
  (`-bench`/`-benchmem`), and profile when needed. Do not claim a speedup from intuition.
- Portability: follow the project's OS/architecture/CGO matrix. Cross-compilation
  establishes buildability for that configuration, not successful target execution.

References: https://go.dev/wiki/TestComments and https://pkg.go.dev/testing.
