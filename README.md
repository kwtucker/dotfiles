# Dotfiles

## Intstallation:

```
git clone git@github.com:kwtucker/dotfiles ~/.dotfiles
cd ~/.dotfiles && . ./bootstrap
```

##### 1. Go to ~/.whalebyte directory

```
mkdir -p ~/.whalebyte/{Code,notes} ; touch ~/.whalebyte/.secret .env
```

##### 2. Setup dotfile components

*NOTE*: Make sure if needed to create local files first:
 - git: [user] name and email and [url] instead of mapping
 - zsh: environment variables with usernames and tokens set.

```shell
git/config.local
zsh/local.zsh
```

##### 4. Then install vim plugins.

*Install*: [vim-plug](https://github.com/junegunn/vim-plug)

```shell
  $ vim
  :PlugInstall
```

## Credits

Influneced by and examples taken from:

[mnarrell](https://github.com/mnarrell/dotfiles)

