# image/Dockerfile — public workspace image (remote Go dev + k8s debug).
#
# Build from the repo root so explicit COPY paths below stay valid:
#   docker build -f image/Dockerfile -t ghcr.io/kwtucker/workspace:local .
#
# Design notes:
# - Ubuntu 24.04 (glibc) because mise aqua backends + neovim/LazyVim need it.
# - USER dev (uid 1000) + passwordless sudo. Override to root at runtime only
#   when a debug session truly needs it (docker --user root / runAsUser: 0).
# - Fonts intentionally NOT installed: glyphs render in your local terminal
#   emulator from its own Nerd Font, never from container fontconfig.
# - Explicit COPY list (not COPY .) so machine-local secrets can never bake
#   in, even if someone builds with uncommitted files present. Mirrors
#   ../.gitignore (zsh/local, git/config.local, modules.local.mk, *.secret).

FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    XDG_CONFIG_HOME=/home/dev/.config \
    XDG_CACHE_HOME=/home/dev/.cache \
    XDG_DATA_HOME=/home/dev/.local/share \
    MISE_YES=1 \
    GOTOOLCHAIN=local \
    WORKSPACE_IMAGE=1

# Base deps: shell, VCS, network/debug, Go build essentials, tmux.
# mise manages all dev-tool versions (see mise.workspace.toml).
RUN apt-get update && apt-get install -y --no-install-recommends \
      zsh git curl wget ca-certificates sudo less unzip locales \
      procps lsof strace tcpdump dnsutils iputils-ping netcat-openbsd \
      openssh-client man-db tmux \
      build-essential pkg-config libssl-dev \
      zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev \
      libncurses-dev xz-utils \
    && rm -rf /var/lib/apt/lists/* \
    && locale-gen C.UTF-8

# Non-root dev user first so every layer below is correctly owned.
# Ubuntu >= 23.04 ships an `ubuntu` user on uid 1000 — remove it so `dev`
# can take uid 1000 (matches runAsUser: 1000 in k8s/dev-pod.yaml).
RUN (id ubuntu >/dev/null 2>&1 && userdel -r ubuntu || true) \
    && useradd -m -s /usr/bin/zsh -u 1000 dev \
    && echo "dev ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/dev \
    && chmod 0440 /etc/sudoers.d/dev \
    && mkdir -p /home/dev/work /home/dev/.config/mise /home/dev/.local/bin \
    && chown -R dev:dev /home/dev

# Explicit dotfile payload — keep in sync with the make modules invoked below.
# Anything not listed here (zsh/local, git/config.local, *.secret, .git)
# cannot end up in the image.
COPY --chown=dev:dev Makefile env.mk platform.mk install mise.toml \
  /home/dev/.dotfiles/
COPY --chown=dev:dev image/mise.workspace.toml /home/dev/.dotfiles/image/mise.workspace.toml
COPY --chown=dev:dev image/entrypoint.sh /home/dev/.dotfiles/image/entrypoint.sh
COPY --chown=dev:dev zsh/  /home/dev/.dotfiles/zsh/
COPY --chown=dev:dev nvim/ /home/dev/.dotfiles/nvim/
COPY --chown=dev:dev fzf/  /home/dev/.dotfiles/fzf/
COPY --chown=dev:dev tmux/ /home/dev/.dotfiles/tmux/
COPY --chown=dev:dev git/  /home/dev/.dotfiles/git/
COPY --chown=dev:dev bin/  /home/dev/.dotfiles/bin/
COPY --chown=dev:dev bat/  /home/dev/.dotfiles/bat/
COPY --chown=dev:dev ripgrep/ /home/dev/.dotfiles/ripgrep/
COPY --chown=dev:dev psql/ /home/dev/.dotfiles/psql/
COPY --chown=dev:dev golang/ /home/dev/.dotfiles/golang/
COPY --chown=dev:dev kubernetes/ /home/dev/.dotfiles/kubernetes/
COPY --chown=dev:dev helm/ /home/dev/.dotfiles/helm/
COPY --chown=dev:dev docker/ /home/dev/.dotfiles/docker/

# All RUNs below use bash, not /bin/sh (dash): `mise activate bash` emits
# bashisms (typeset, arrays) that abort dash with a syntax error (exit 2).
SHELL ["/bin/bash", "-euo", "pipefail", "-c"]

USER dev
WORKDIR /home/dev
ENV HOME=/home/dev \
    PATH=/home/dev/.local/bin:/home/dev/.local/share/mise/shims:/home/dev/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# 1. Toolchain: mise + slim toolset (own layer so CI logs show mise failures).
# github_token is a BuildKit *secret* (see workspace-image.yaml), never an
# ARG — it can't linger in layer history. aqua + mise's github backend read
# GITHUB_TOKEN for api.github.com calls; without it, anonymous CI calls get
# rate-limited on shared runners. Local `docker build` without the secret
# still works via the `if` guard (anonymous quota). The sentinel loop fails
# the layer LOUD if any API-backed tool didn't install — a green-but-partial
# image (e.g. missing nvim) must never ship again.
RUN --mount=type=secret,id=github_token \
    if [ -f /run/secrets/github_token ]; then export GITHUB_TOKEN="$(cat /run/secrets/github_token)"; fi \
    && curl https://mise.run | sh \
    && ln -sf /home/dev/.dotfiles/image/mise.workspace.toml /home/dev/.config/mise/config.toml \
    && eval "$(/home/dev/.local/bin/mise activate bash)" \
    && mise trust /home/dev/.dotfiles/image/mise.workspace.toml \
    && mise install --yes \
    && for b in nvim rg fzf starship k9s; do test -x "/home/dev/.local/share/mise/shims/$b" || { echo "MISSING mise tool: $b"; exit 1; }; done \
    && find /home/dev/.local/share/mise/installs -type f -exec chmod +x {} + 2>/dev/null || true

# 2. Dotfiles: symlinks + shell/editor modules.
# Skip fonts/alacritty/whalebyte/terraform/rust/opencode: client-side or
# unneeded in the container. zsh curls antigen, tmux clones TPM,
# nvim bootstraps lazy.nvim — all need network at build time by design.
RUN make -C /home/dev/.dotfiles zsh \
    && make -C /home/dev/.dotfiles nvim \
    && make -C /home/dev/.dotfiles fzf \
    && make -C /home/dev/.dotfiles tmux \
    && make -C /home/dev/.dotfiles git \
    && make -C /home/dev/.dotfiles golang

# 2b. Pre-warm: run one non-interactive login shell so antigen clones its
# bundles and compinit writes its dump into this layer. Fresh containers
# then skip first-run downloads and hit a prompt in ~2s.
RUN zsh -ic true

# 3. Dotfiles: k8s/infra + CLI modules (own layer for debuggable logs).
RUN make -C /home/dev/.dotfiles kubernetes \
    && make -C /home/dev/.dotfiles helm \
    && make -C /home/dev/.dotfiles bat \
    && make -C /home/dev/.dotfiles ripgrep \
    && make -C /home/dev/.dotfiles bin \
    && make -C /home/dev/.dotfiles psql \
    && make -C /home/dev/.dotfiles docker

# 4. Pre-warm editor: Lazy plugins + Mason LSP/tools, then clean caches.
# lazy.nvim is cloned explicitly with NO `|| true`: the lazy.lua bootstrap
# uses vim.fn.system, whose failures surface only as a cryptic E5113 at
# startup while `|| true` ships a green-but-editorless image. A loud git
# failure here beats that. (The braces keep `|| true` scoped to the Lazy
# step so it can't neutralize a clone failure — && and || are
# left-associative.)
# `Lazy! sync` (NOT `install`): verified locally that `sync` fully engages
# headless (clones + builds + treesitter parsers, with log output) while
# `install` silently no-ops headless (RC=0, zero plugins — its runner never
# gets pumped without the sync view). `sync`'s clean step is safe here:
# lazy.nvim adds itself to the spec (plugin.lua), so it is never "unused".
# The `test -d` assertions fail the build LOUD if the dir ever goes missing,
# so a broken editor can never ship green again either way.
# The MasonInstall list must match the WORKSPACE_IMAGE subset in
# nvim/lua/plugins/mason.lua (source of truth). MasonInstall is async, so
# the lua wait polls the registry until every package reports installed
# (20 min cap) before quitting — otherwise +qa would kill slow installs
# (notably the go tools, which compile from source).
RUN rm -rf /home/dev/.local/share/nvim/lazy/lazy.nvim \
    && git clone --filter=blob:none --branch=stable https://github.com/folke/lazy.nvim.git /home/dev/.local/share/nvim/lazy/lazy.nvim \
    && test -d /home/dev/.local/share/nvim/lazy/lazy.nvim/lua \
    && { nvim --headless "+Lazy! sync" +qa || true; } \
    && test -d /home/dev/.local/share/nvim/lazy/lazy.nvim/lua \
    && nvim --headless \
      '+MasonInstall docker-compose-language-service dockerfile-language-server gofumpt goimports golangci-lint golangci-lint-langserver gomodifytags gopls json-lsp lua-language-server shellcheck shfmt staticcheck stylua taplo terraform-ls yaml-language-server' \
      '+lua vim.wait(1200000, function() local ok, reg = pcall(require, "mason-registry") if not ok then return false end for _, name in ipairs({ "docker-compose-language-service", "dockerfile-language-server", "gofumpt", "goimports", "golangci-lint", "golangci-lint-langserver", "gomodifytags", "gopls", "json-lsp", "lua-language-server", "shellcheck", "shfmt", "staticcheck", "stylua", "taplo", "terraform-ls", "yaml-language-server" }) do if not reg.is_installed(name) then return false end end return true end, 5000)' \
      '+qa' || true \
    && mise reshim \
    && rm -rf /home/dev/.cache/mise /tmp/*

WORKDIR /home/dev/work

ENTRYPOINT ["/home/dev/.dotfiles/image/entrypoint.sh"]
CMD ["sleep", "infinity"]
