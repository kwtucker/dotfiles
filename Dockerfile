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
    python3 \
    python3-pip \
    && locale-gen en_US.UTF-8 \
    && rm -rf /var/lib/apt/lists/*

ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

# --- Python provider for neovim (luarocks needs it) ---
RUN pip3 install --break-system-packages pynvim

# --- Install mise system-wide ---
ENV MISE_DATA_DIR=/opt/mise/data
ENV MISE_CONFIG_DIR=/opt/mise/config
ENV MISE_INSTALL_PATH=/usr/local/bin/mise
ENV MISE_YES=1

RUN curl https://mise.run | sh \
    && chmod -R a+rx /usr/local/bin/mise

# --- Write global mise config so trust prompts never appear ---
RUN mkdir -p /opt/mise/config \
    && echo '[settings]' > /opt/mise/config/config.toml \
    && echo 'yes = true' >> /opt/mise/config/config.toml \
    && echo 'not_found_auto_install = false' >> /opt/mise/config/config.toml \
    && mkdir -p /root/.config/mise \
    && cp /opt/mise/config/config.toml /root/.config/mise/config.toml

# --- Pre-install all tools ---
COPY mise.toml /opt/mise/config/config.toml
RUN mise install --yes \
    && mise exec node -- npm install -g neovim \
    && chmod -R a+rx /opt/mise/data \
    && find /opt/mise/data/installs -type f -name "*" -exec chmod a+rx {} +

ENV PATH=/opt/mise/data/shims:/opt/mise/data/installs/node/22.9.0/bin:/usr/local/bin:$PATH

# --- Non-root user ---
# Ubuntu 24.04 ships with a default 'ubuntu' user at UID 1000 - remove it first
RUN userdel -r ubuntu 2>/dev/null || true \
    && groupadd --gid ${USER_GID} ${USERNAME} \
    && useradd --uid ${USER_UID} --gid ${USER_GID} -m -s /bin/zsh ${USERNAME} \
    && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME}

# --- Write mise config for all users ---
RUN mkdir -p /etc/skel/.config/mise \
    && echo '[settings]' > /etc/skel/.config/mise/config.toml \
    && echo 'yes = true' >> /etc/skel/.config/mise/config.toml \
    && echo 'not_found_auto_install = false' >> /etc/skel/.config/mise/config.toml

# --- Shell activation for all users ---
RUN echo 'export MISE_DATA_DIR=/opt/mise/data' > /etc/profile.d/mise.sh \
    && echo 'export MISE_CONFIG_DIR=/opt/mise/config' >> /etc/profile.d/mise.sh \
    && echo 'export MISE_YES=1' >> /etc/profile.d/mise.sh \
    && echo 'export PATH=/opt/mise/data/shims:/usr/local/bin:$PATH' >> /etc/profile.d/mise.sh \
    && echo 'eval "$(mise activate bash)"' >> /etc/bash.bashrc \
    && echo 'eval "$(mise activate zsh)"' >> /etc/zsh/zshenv \
    && chmod a+rx /etc/profile.d/mise.sh

# Create XDG_RUNTIME_DIR for neovim server socket
RUN mkdir -p /run/user/1000 && chmod 700 /run/user/1000 && chown 1000:1000 /run/user/1000

ENV XDG_RUNTIME_DIR=/run/user/1000
ENV TERM=xterm-256color
ENV COLORTERM=truecolor

CMD ["/bin/zsh"]
