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
RUN curl https://mise.run | sh \
    && ln -sf /home/dev/.dotfiles/image/mise.workspace.toml /home/dev/.config/mise/config.toml \
    && eval "$(/home/dev/.local/bin/mise activate bash)" \
    && mise trust /home/dev/.dotfiles/image/mise.workspace.toml \
    && mise install --yes \
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

# 4. Pre-warm editor + clean caches to keep the image lean.
RUN nvim --headless "+Lazy! sync" +qa || true \
    && mise reshim \
    && rm -rf /home/dev/.cache/mise /tmp/*

WORKDIR /home/dev/work

ENTRYPOINT ["/home/dev/.dotfiles/image/entrypoint.sh"]
CMD ["sleep", "infinity"]
