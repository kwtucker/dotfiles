#!/usr/bin/env fish
#
# bootstrap

set DOTFILES_ROOT (pwd -P)

for f in $DOTFILES/fish/scripts/helpers
	set -Up fish_function_path $f
end

function info
	echo [(set_color --bold) ' .. ' (set_color normal)] $argv
end

function user
	echo [(set_color --bold) ' ?? ' (set_color normal)] $argv
end

function on_exit -p %self
	if not contains $argv[3] 0
		echo [(set_color --bold red) FAIL (set_color normal)] "Couldn't setup dots, please open an issue at https://github.com/kwtucker/dotfiles"
	end
end

function setup_gitconfig
	set managed (git config --global --get dotfiles.managed)
	# if there is no user.email, we'll assume it's a new machine/setup and ask it
	if test -z (git config --global --get user.email)
		user 'What is your git author name?'
		read user_name
		user 'What is your git author email?'
		read user_email

		test -n $user_name
			or echo "please inform the git author name"
		test -n $user_email
			or abort "please inform the git author email"

		git config --global user.name $user_name
			and git config --global user.email $user_email
			or abort 'failed to setup git user name and email'
	else if test '$managed' = "true"
		# if user.email exists, let's check for dotfiles.managed config. If it is
		# not true, we'll backup the gitconfig file and set previous user.email and
		# user.name in the new one
		set user_name (git config --global --get user.name)
			and set user_email (git config --global --get user.email)
			and mv ~/.gitconfig ~/.gitconfig.backup
			and git config --global user.name $user_name
			and git config --global user.email $user_email
			and success "moved ~/.gitconfig to ~/.gitconfig.backup"
			or abort 'failed to setup git user name and email'
	else
		# otherwise this gitconfig was already made by the dotfiles
		info "already managed by dotfiles"
	end
	# include the gitconfig.local file
	# finally make git knows this is a managed config already, preventing later
	# overrides by this script
	git config --global include.path ~/.gitconfig.local
		and git config --global dotfiles.managed true
		or abort 'failed to setup git'
end

functiion set_xdg
	set -U fish_user_paths XDG_CONFIG_HOME=${HOME}/.configi $fish_user_paths
  	set -U fish_user_paths XDG_CACHE_HOME=${HOME}/.cache $fish_user_paths
  	set -U fish_user_paths XDG_DATA_HOME=${HOME}/.local/share $fish_user_paths
  	set -U fish_user_paths XDG_RUNTIME_DIR=${HOME}/tmp/xdg_runtime $fish_user_paths

function install_dotfiles
	for src in $DOTFILES_ROOT/fish/**/*.symlink
		link_file $src $HOME/.(basename $src .symlink) backup
			or abort 'failed to link config file'
	end

	if test -f ~/.extra/plugins/fish_plugins
		link_file ~/.extra/plugins/fish_plugins $__fish_config_dir/fish_plugins backup
			or abort plugins
	end

	# link_file $DOTFILES_ROOT/fish/bat/config $HOME/.config/bat/config backup
	# 	or abort bat
	# link_file $DOTFILES_ROOT/ssh/config.dotfiles $HOME/.ssh/config.dotfiles backup
	# 	or abort ssh
end

curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
	and success 'fisher'
	or abort 'fisher'

mkdir -p ~/.extra/functions/
	and success '.extra/functions'
	or abort '.extra/functions'

mkdir -p ~/.extra/plugins/
	and success '.extra/plugins'
	or abort '.extra/plugins'

for plugin in ~/.extra/plugins/*
	if test -d $plugin
		fisher install $plugin
	end
end

set_xdg
	and success 'xdg'
	or abort 'xdg'

install_dotfiles
	and success 'dotfiles'
	or abort 'dotfiles'

setup_gitconfig
	and success 'gitconfig'
	or abort 'gitconfig'

fisher update
	and success 'plugins'
	or abort 'plugins'

mkdir -p ~/.config/fish/completions/
	and success 'completions'
	or abort 'completions'

for installer in $DOTFILES_ROOT/**/install.fish
	fish $installer
		and success $installer
		or abort $installer
end

test (which fish) = $SHELL
	and success 'dotfiles installed/updated!'
	and exit 0

chsh -s (which fish)
	and success set (fish --version) as the default shell
	or abort 'set fish as default shell'

success 'dotfiles installed/updated!'
