# Go concurrency and resource lifetimes

Prefer synchronous functions unless concurrency solves a demonstrated problem.
Keep concurrent work bounded and ownership/lifetimes understandable.

## Review before changing concurrent code

- Identify who starts each goroutine, what stops it, and who waits for it. Cover
  normal completion, errors, cancellation, and shutdown. Garbage collection does
  not terminate a blocked goroutine.
- Pass request contexts explicitly, normally as the first parameter. Preserve
  cancellation/deadlines instead of replacing them with `context.Background`.
  Avoid storing request contexts in structs; explain genuine lifecycle exceptions.
  Call cancel functions and ensure blocking operations can actually stop.
- Identify channel senders, receivers, and closure ownership. Close only when all
  senders are done; handle closed-channel receives deliberately. Avoid send-after-
  close panics and blocked sends after a consumer exits. Do not fix synchronization
  problems by guessing a bigger channel buffer.
- Protect shared mutable state consistently. Do not copy mutex-bearing values.
  Keep lock ordering clear and avoid unnecessary locks across callbacks or slow I/O.
  Use atomics only when their invariants and memory-ordering requirements are clear.
- Bound fan-out, queues, and retries. Backpressure, cancellation, and error
  propagation should remain visible. Use existing repository concurrency patterns
  before introducing another abstraction or dependency.
- Define ownership of files, connections, response bodies, timers, tickers, and
  other resources. Follow the supported Go version's semantics rather than stale
  folklore; inspect relevant standard-library documentation when uncertain.

## Validate observable lifetimes

- Test cancellation, timeout, normal completion, error propagation, and shutdown
  behavior where relevant. Include cases where the consumer stops early.
- Coordinate tests with channels, barriers, or version-supported testing facilities
  instead of using sleeps as proof of ordering. Bound test waits so failures explain
  a problem rather than hanging indefinitely; avoid timing-sensitive assertions.
- Use independent fixtures and deliberate cleanup. Do not add goroutine-count
  assertions or blanket `t.Parallel` as a substitute for reasoning about lifetimes.
- Run affected-package race tests where supported and appropriate broader targets.
  Report unsupported race configurations. The race detector does not prove freedom
  from deadlocks, leaks, or all possible data races.

References: https://go.dev/wiki/CodeReviewComments#goroutine-lifetimes,
https://go.dev/doc/articles/race_detector, and https://pkg.go.dev/context.
