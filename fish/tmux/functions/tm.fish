# Search or create tmux session.
function tm -d "create or attach to tmux session." -a name
  if test -n "$TMUX" 
	set change "switch-client" 
  else 
 	set change "attach-session"
  end

  if test -n $name
	tmux $change -t "$name" 2>/dev/null or tmux new-session -d -s $name && tmux $change -t "$name"
	return
  end 
  set session $(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --exit-0) &&  tmux $change -t "$session" || echo "No sessions found."
end
