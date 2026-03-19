# Start Zsh if available, otherwise fallback to Bash
if command -v zsh >/dev/null && [ -z "${ZSH_VERSION-}" ]; then
  echo "🚀 Starting Zsh shell in DevPod..."
  exec zsh
else
  echo "ℹ️ Zsh not found, falling back to Bash"
  exec bash
fi
