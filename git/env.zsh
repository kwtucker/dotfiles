# Reuse an authenticated GitHub CLI login for GitHub-backed mise bumps.
# No token value is stored in the checkout; an explicit token still wins.
if [ -z "${GITHUB_TOKEN:-}" ] && command -v gh >/dev/null 2>&1; then
  __dotfiles_gh_token="$(gh auth token 2>/dev/null || true)"
  [ -n "$__dotfiles_gh_token" ] && export GITHUB_TOKEN="$__dotfiles_gh_token"
  unset __dotfiles_gh_token
fi
