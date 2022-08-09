function tm -d "Create, switch, or attach to tmux session."
  # If TMUX is an empty string attach.
  #If currently in TMUX we want to switch to another session.
  if test -z "$TMUX" 
 	set change "attach-session"
  else 
	set change "switch-client" 
  end

  # If there are arguments that the count is greater than null,
  ## try to switch or attach to the session. If no session exists create one.
  if count $argv[1] > /dev/null
	if tmux $change -t "$argv[1]" 2>/dev/null   
		tmux $change -t "$argv[1]"
	else
		tmux new-session -A -s $argv[1]
	end
	return
  end 

  # Fuzzy find the session and attach or switch to it. If a session doesn't exist, exit.
  set session $(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --exit-0)
  if test -z $session
	echo "No sessions found."
  else
	tmux $change -t "$session" 
  end
end
