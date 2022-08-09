# Search or create tmux session.
function tm -d "create or attach to tmux session." -a $1
  if test -n "$TMUX" 
	set change "switch-client" 
  else 
 	set change "attach-session"
  end

  if test -n $1
	tmux $change -t "$1" 2>/dev/null or tmux new-session -d -s $1 && tmux $change -t "$1"
	return
  end 
  set session $(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --exit-0) &&  tmux $change -t "$session" || echo "No sessions found."
end
