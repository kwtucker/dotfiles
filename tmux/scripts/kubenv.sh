show_kubenv() { # save this module in a file with the name kubenv.sh
	local index=$1 # this variable is used by the module loader in order to know the position of this module
	local icon="$(get_tmux_option "@catppuccin_kubenv_icon" "")"
	local color="$(get_tmux_option "@catppuccin_kubenv_color" "$thm_blue")"
	local text="$(get_tmux_option "@catppuccin_kubenv_text" "CTX: #(kubectl config current-context) | NS: #(kubectl config view --minify | grep namespace: | awk 'NR>0 {print \$2}')")"
	local module=$(build_status_module "$index" "$icon" "$color" "$text")

	echo "$module"
}
