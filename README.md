# .Files
> Modular, portable, XDG-compliant dotfiles for Zsh, Neovim, tmux, Git, and other developer tools.
## 🚀 Installation

### 1. Clone the Repository

```bash
git clone git@github.com:kwtucker/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```


### 2. Setup dotfile components

_NOTE_: Make sure if needed to create local files first:

- modules: specify the modules to install outside the defaults. "LOCAL_MODULES = terraform"
- git: [user] name and email and [url] instead of mapping.
- zsh: environment variables with usernames and tokens set.

```shell
.dotfiles/modules.local.mk
.dotfiles/git/config.local
.dotfiles/zsh/local
```

### 3. Bootstrap All Modules

```shell
make all
```


## ⚡ Makefile Commands

| Target           | Description                                       |
| ---------------- | ------------------------------------------------- |
| `make all`       | Install all modules                               |
| `make clean.all` | Remove all installed modules and files            |
| `make [module]`       | Install a specific module (e.g., `make zsh`)      |
| `make [module].clean` | Clean a specific module (e.g., `make nvim.clean`) |
| `make help`      | List all available targets                        |


## Credits

Influneced by and examples taken from:

[mnarrell](https://github.com/mnarrell/dotfiles)
