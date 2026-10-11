# Search or create tmux session.
function tm() {
  # A tmux upgrade (e.g. via mise, which tracks `latest`) can leave an old
  # server running behind the newer client. Attaching across that version
  # mismatch fails with "open terminal failed: not a terminal" — so drop the
  # stale server before we try to attach. Skip when already inside tmux, since
  # the server we're attached to already matches our client.
  if [[ -z "$TMUX" ]]; then
    local _cver _sver
    _cver=$(tmux -V 2>/dev/null | sed 's/^tmux //')
    _sver=$(tmux display-message -p '#{version}' 2>/dev/null)
    if [[ -n "$_sver" && "$_sver" != "$_cver" ]]; then
      tmux kill-server
    fi
    unset _cver _sver
  fi

  # Determine attach vs switch
  [[ -n "$TMUX" ]] && change="switch-client" || change="attach-session"

  # If argument provided, attach/create it
  if [[ -n "$1" ]]; then
    if tmux has-session -t "$1" 2>/dev/null; then
      tmux $change -t "$1"
    else
      tmux new-session -s "$1"
    fi
    return
  fi

  # Get existing sessions
  sessions=$(tmux list-sessions -F "#{session_name}" 2>/dev/null)

  # If no sessions exist, create "main"
  if [[ -z "$sessions" ]]; then
    tmux new-session -s main
    return
  fi

  # Prepend the "Create a new session" option
  session_list=$(printf "Create a new session\n%s\n" "$sessions")

  # Show fzf for selection
  selected=$(printf '%s\n' "$session_list" | fzf \
             --prompt="Pick a session: " \
             --exit-0)

  # If nothing selected, exit
  [[ -z "$selected" ]] && return

  if [[ "$selected" == "Create a new session" ]]; then
    # Prompt for the new session name
    print -n "Enter a new session name (empty to cancel): "
    read session
    [[ -z "$session" ]] && return
  else
    # Attach to selected existing session
    session="$selected"
  fi

  # Attach if exists, else create
  if tmux has-session -t "$session" 2>/dev/null; then
    tmux $change -t "$session"
  else
    tmux new-session -s "$session"
  fi
}

# zsh; needs setopt re_match_pcre. Kill session
function tmk () {
    local sessions
    sessions="$(tmux ls|fzf --exit-0 --multi)"  || return $?
    local i
    for i in "${(f@)sessions}"
    do
        [[ $i =~ '([^:]*):.*' ]] && {
            echo "Killing $match[1]"
            tmux kill-session -t "$match[1]"
        }
    done
}
