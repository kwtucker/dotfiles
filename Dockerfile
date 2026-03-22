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

# --- Install mise system-wide so any user can access tools ---
# Tools go to /opt/mise so they survive regardless of which user DevPod picks
ENV MISE_DATA_DIR=/opt/mise/data
ENV MISE_CONFIG_DIR=/opt/mise/config
ENV MISE_INSTALL_PATH=/usr/local/bin/mise
RUN curl https://mise.run | sh \
    && chmod -R a+rx /usr/local/bin/mise

# --- Copy mise config and pre-install all tools as root ---
COPY mise.toml /opt/mise/config/config.toml
RUN MISE_YES=1 mise install --yes \
    && MISE_YES=1 mise exec node -- npm install -g neovim \
    && chmod -R a+rx /opt/mise/data

ENV PATH=/opt/mise/data/shims:/opt/mise/data/installs/node/22.9.0/bin:/usr/local/bin:$PATH

# --- Non-root user ---
# Ubuntu 24.04 ships with a default 'ubuntu' user at UID 1000 - remove it first
RUN userdel -r ubuntu 2>/dev/null || true \
    && groupadd --gid ${USER_GID} ${USERNAME} \
    && useradd --uid ${USER_UID} --gid ${USER_GID} -m -s /bin/zsh ${USERNAME} \
    && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME}

# --- Pre-trust mise config locations so no prompt ever appears ---
RUN mkdir -p /opt/mise/config     && printf "[settings]
yes = true
not_found_auto_install = false
" > /opt/mise/config/config.toml     && mkdir -p /root/.config/mise     && printf "[settings]
yes = true
not_found_auto_install = false
" > /root/.config/mise/config.toml

# --- Shell activation for all users ---
RUN echo 'export MISE_DATA_DIR=/opt/mise/data' >> /etc/profile.d/mise.sh \
    && echo 'export MISE_CONFIG_DIR=/opt/mise/config' >> /etc/profile.d/mise.sh \
    && echo 'export PATH=/opt/mise/data/shims:/usr/local/bin:$PATH' >> /etc/profile.d/mise.sh \
    && echo 'eval "$(mise activate bash)"' >> /etc/bash.bashrc \
    && echo 'eval "$(mise activate zsh)"' >> /etc/zsh/zshenv \
    && chmod a+rx /etc/profile.d/mise.sh

ENV MISE_YES=1
ENV TERM=xterm-256color
ENV COLORTERM=truecolor

CMD ["/bin/zsh"]
