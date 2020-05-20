# .Files

## Clone:

```
git clone git@github.com:kwtucker/dotfiles ~/.dotfiles
```

##### 1. Create the ~/.whalebyte directory

```
mkdir -p ~/.whalebyte/{code,notes} ; touch ~/.whalebyte/.secret .env
```

##### 2. Setup dotfile components

*NOTE*: Make sure if needed to create local files first:
 - git: [user] name and email and [url] instead of mapping
 - zsh: environment variables with usernames and tokens set.

```shell
.dotfiles/git/config.local
.dotfiles/zsh/local.zsh
```

##### 3. Install Dotfiles

```
cd ~/.dotfiles && . ./bootstrap
```

## Credits

Influneced by and examples taken from:

[mnarrell](https://github.com/mnarrell/dotfiles)

