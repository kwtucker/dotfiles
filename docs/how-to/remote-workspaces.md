# Use dotfiles in remote workspaces

These workflows apply configuration and download tools on the target host.
Use a profile appropriate to that host and avoid storing credentials in workspace
configuration or this repository.

## SSH host

Follow the [first-install tutorial](../tutorials/first-install.md) on the remote
machine. For a host without a graphical terminal, explicitly set
`DOTFILES_SKIP_FONTS=1 ./install` if the selected profile includes fonts. SSH
alone does not trigger automatic font skipping.

## DevPod

From the computer running DevPod:

```sh
devpod up PROJECT_REPOSITORY \
  --dotfiles https://github.com/kwtucker/dotfiles \
  --dotfiles-script install \
  --ide none
```

An explicit install script avoids relying on auto-detection. To select `dev`
and skip fonts, check your installed DevPod version's supported environment
flags before using:

```sh
devpod up PROJECT_REPOSITORY \
  --dotfiles https://github.com/kwtucker/dotfiles \
  --dotfiles-script install --ide none \
  --dotfiles-script-env DOTFILES_PROFILE=dev DOTFILES_SKIP_FONTS=1
```

Set context defaults with `devpod context set-options` using `DOTFILES_URL` and
`DOTFILES_SCRIPT` if supported by your version. Git credential forwarding is
workspace/client configuration; the dotfiles installer does not provision it.

## Devcontainer

For a project you control, adapt its existing `devcontainer.json` rather than
overwriting it:

```jsonc
{
  "containerEnv": {
    "DOTFILES_PROFILE": "dev",
    "DOTFILES_SKIP_FONTS": "1"
  },
  "postCreateCommand": "[ -d ~/.dotfiles ] || git clone https://github.com/kwtucker/dotfiles.git ~/.dotfiles; ~/.dotfiles/install"
}
```

The hook can update an existing checkout and install tools; it is not simply a
clone check. Use a suitable user-scoped lifecycle hook and forwarded credentials
for private repositories. Never embed tokens or private keys in this JSON.

Docker, Codespaces, and `REMOTE_CONTAINERS` detection can skip font downloads;
an explicit environment flag makes your intended behavior clear. Rebuilds may
discard ignored `profile.local`, so workspace-provided environment selection
is preferable for ephemeral machines.

## Inspect and use debugging containers

Inside the workspace, run `make profile.show`, `make status`, and `make doctor`
from the dotfiles checkout. Do not interpret config checks as proof that all
editor integrations or model providers work on that platform.

The separate [k8s-debug project](https://github.com/kwtucker/k8s-debug) consumes
this repository's editor config at a pinned revision. `K8S_DEBUG=1` suppresses
Mason profile installation; it does not install a debug container or grant
cluster permissions. See the [Kubernetes module](../../kubernetes/README.md).
