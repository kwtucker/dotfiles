# profiles.mk — tracked install-time module sets.
#
# A profile chooses which modules `make all` and `./install` link on a machine.
# It is not a runtime shell mode: every installed module is available in every
# terminal. Local overrides (modules.local.mk, mise.local.toml, git/config.local,
# zsh/local) stay machine-specific and untracked.
#
# PROFILE selection precedence is documented in the root Makefile:
#   PROFILE=<name> > DOTFILES_PROFILE > profile.local > full

MINIMAL_MODULES := bin zsh tmux git tig fzf nvim agents
DEV_MODULES := $(MINIMAL_MODULES) golang bat ripgrep rust docker opencode
INFRA_MODULES := $(DEV_MODULES) kubernetes helm terraform psql sops whalebyte
WORKSTATION_MODULES := $(DEV_MODULES) alacritty fonts
FULL_MODULES := \
	bin zsh alacritty fzf tmux git tig golang kubernetes helm terraform docker \
	bat nvim psql ripgrep fonts rust agents opencode sops whalebyte

PROFILE_NAMES := minimal dev infra workstation full

PROFILE_DESCRIPTION_minimal := Shell, git, tmux, tig, fzf, editor, agents
PROFILE_DESCRIPTION_dev := Minimal plus common language and development tools
PROFILE_DESCRIPTION_infra := Dev plus Kubernetes, Terraform, Docker, psql, secrets
PROFILE_DESCRIPTION_workstation := Dev plus Alacritty and Nerd Fonts
PROFILE_DESCRIPTION_full := Every default module, including secrets tooling

PROFILE_MODULES_minimal := $(MINIMAL_MODULES)
PROFILE_MODULES_dev := $(DEV_MODULES)
PROFILE_MODULES_infra := $(INFRA_MODULES)
PROFILE_MODULES_workstation := $(WORKSTATION_MODULES)
PROFILE_MODULES_full := $(FULL_MODULES)

# No explicit profile keeps today's full install.
DEFAULT_MODULES := $(FULL_MODULES)
