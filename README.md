# .Files

## Clone

```shell
git clone git@github.com:kwtucker/dotfiles ~/.dotfiles
```

### 1. Create the ~/.whalebyte directory

```shell
mkdir -p ~/.whalebyte/{code,notes} ; touch ~/.whalebyte/.secret .env
```

### 2. Setup dotfile components

_NOTE_: Make sure if needed to create local files first:

- modules: specify the modules to install outside the defaults. "LOCAL_MODULES = terraform"
- git: [user] name and email and [url] instead of mapping.
- zsh: environment variables with usernames and tokens set.

```shell
.dotfiles/modules.local.mk
.dotfiles/git/config.local
.dotfiles/zsh/local.zsh
```

### 3. Install Dotfiles

```shell
cd ~/.dotfiles && . ./bootstrap
```

## Credits

Influneced by and examples taken from:

[mnarrell](https://github.com/mnarrell/dotfiles)
