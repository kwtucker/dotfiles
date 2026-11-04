# Go security and dependency review

Review trust boundaries and actual data flows, not just linter findings. Stay
within the task's scope; report unrelated risks without silently redesigning code.

## Security-sensitive code

- Identify untrusted inputs and constrain lengths, allocation sizes, recursion,
  decoding, and processing time where relevant. Treat invalid and partial input as
  expected errors. Consider integer conversion/overflow and nil-versus-empty behavior.
- Use parameterized database queries. Avoid constructing shell commands from
  untrusted data; prefer executable arguments and still consider option injection.
- Review filesystem traversal and symlink behavior against the intended boundary;
  string cleaning alone is not a general containment guarantee.
- For network clients/servers, review timeouts, response-body cleanup, input limits,
  authentication/authorization, redirect behavior, and SSRF boundaries as relevant.
  Do not disable TLS verification as a workaround. Keep secrets out of logs/errors.
- Use standard, version-appropriate cryptographic facilities and `crypto/rand` for
  security-sensitive randomness. Do not invent cryptography or ad hoc authentication.

## Dependency changes and vulnerability checks

- Confirm the API and behavior against the exact dependency version in use. Review
  module-file diffs, minimum Go versions, replacements, and compatibility effects.
- For dependency changes, security-sensitive work, or an explicit audit, use the
  repository's vulnerability target, gopls `go_vulncheck`, or `govulncheck ./...`.
  Choose one suitable mechanism rather than running equivalent scans repeatedly.
- Use the intended affected modules, tags, platform, CGO, and build configuration.
  A workspace is not necessarily one module; state the actual scan scope.
- Report advisories and available reachability information accurately. A clean
  scan is not evidence that authentication, authorization, input handling, or
  business logic is secure. Report network/database failures as failed or blocked
  checks, not as clean results.
- Do not auto-upgrade dependencies, alter `go.mod`/`go.sum`, or suppress findings
  without authorization. Explain proposed fixes and compatibility tradeoffs.
- Do not trigger a networked vulnerability scan for every session or trivial edit.
  Prefer scheduled CI audits for ongoing coverage; add CI only when requested.

References: https://go.dev/doc/security/best-practices and
https://go.dev/doc/tutorial/govulncheck.
