# syntax=docker/dockerfile:1
#
# Dev environment image - LazyVim edition.
# - Treesitter needs: gcc, g++, make (to compile parsers)
# - Mason needs: node (for LSP installers), curl, unzip, tar
# - Telescope needs: ripgrep, fd (installed via mise)
# - LSPs pre-installed via mise so first neovim launch is fast
#
# Pushed to: ghcr.io/kwtucker/dotfiles-devenv:latest

FROM ubuntu:24.04

ARG USERNAME=dev
ARG USER_UID=1000
ARG USER_GID=1000

# --- System deps ---
# gcc/g++/make/cmake: Treesitter parser compilation
RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    zsh \
    curl \
    git \
    make \
    cmake \
    gcc \
    g++ \
    sudo \
    ca-certificates \
    unzip \
    tar \
    xz-utils \
    tmux \
    openssh-client \
    xclip \
    locales \
    && locale-gen en_US.UTF-8 \
    && rm -rf /var/lib/apt/lists/*

ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

# --- Non-root user ---
# Ubuntu 24.04 ships with a default 'ubuntu' user at UID 1000 - remove it first
RUN userdel -r ubuntu 2>/dev/null || true \
    && groupadd --gid ${USER_GID} ${USERNAME} \
    && useradd --uid ${USER_UID} --gid ${USER_GID} -m -s /bin/zsh ${USERNAME} \
    && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME}

USER ${USERNAME}
WORKDIR /home/${USERNAME}

# --- Mise ---
RUN curl https://mise.run | sh

ENV PATH=/home/${USERNAME}/.local/bin:/home/${USERNAME}/.local/share/mise/shims:$PATH

# --- Pre-install all tools ---
# Baked into the image so neovim's first launch has gopls, ripgrep,
# fd, node etc. immediately available - no waiting for Mason to sync.
COPY --chown=${USERNAME} mise.toml /home/${USERNAME}/.config/mise/config.toml
RUN mise install --yes

# --- npm global: neovim node provider ---
# Required by plugins that use the neovim node client (e.g. copilot.vim)
RUN mise exec node -- npm install -g neovim

# --- Shell activation ---
RUN printf '\neval "$(mise activate zsh)"\n' >> /home/${USERNAME}/.zshrc \
    && printf '\neval "$(mise activate bash)"\n' >> /home/${USERNAME}/.bashrc

ENV TERM=xterm-256color
ENV COLORTERM=truecolor

CMD ["/bin/zsh"]
