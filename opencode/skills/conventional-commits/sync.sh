#!/usr/bin/env bash
# Re-sync vendored conventional-commits skill from upstream claude-kit.
# Usage: ./sync.sh [--sha <commit-sha>]
# Default ref is main. Pass --sha to pin to a specific upstream commit.
set -euo pipefail

SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
UPSTREAM_BASE_DEFAULT="https://raw.githubusercontent.com/dantuck/claude-kit/main/skills/conventional-commits"
REF="main"

if [[ "${1:-}" == "--sha" && -n "${2:-}" ]]; then
  REF="$2"
fi
UPSTREAM_BASE="https://raw.githubusercontent.com/dantuck/claude-kit/${REF}/skills/conventional-commits"

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

echo "Fetching upstream SKILL.md + specification.md (ref: ${REF})..."
curl -fsSL "${UPSTREAM_BASE}/SKILL.md" -o "${TMP_DIR}/SKILL.upstream.md"
curl -fsSL "${UPSTREAM_BASE}/references/specification.md" -o "${TMP_DIR}/specification.md"

# Re-apply OpenCode adaptations:
# 1. name: commit -> name: conventional-commits (must match folder name)
# 2. drop Claude-only `user-invocable: true`
# 3. append Reference pointer if not already present
python3 - "${TMP_DIR}/SKILL.upstream.md" "${SKILL_DIR}/SKILL.md" <<'PY'
import re, sys
src, dst = sys.argv[1], sys.argv[2]
text = open(src).read()
text = text.replace("name: commit", "name: conventional-commits")
text = re.sub(r"^user-invocable:\s*true\n", "", text, flags=re.MULTILINE)
pointer = "For the full specification, see `references/specification.md`"
if pointer not in text:
    text = text.rstrip() + "\n\n---\n\n## Reference\n\nFor the full specification, see `references/specification.md` (vendored from https://www.conventionalcommits.org/en/v1.0.0/).\n"
open(dst, "w").write(text)
print(f"Wrote {dst}")
PY

cp "${TMP_DIR}/specification.md" "${SKILL_DIR}/references/specification.md"
echo "Wrote ${SKILL_DIR}/references/specification.md"

echo ""
echo "Done. Upstream ref: ${REF}"
echo "Check the real SHA with: git ls-remote https://github.com/dantuck/claude-kit.git HEAD"
echo "Then update UPSTREAM.md and review with: git diff"
