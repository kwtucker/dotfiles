# movetag 1.0.0
movetaghead() {
	git push origin :$1 && git tag -fa -m "moving tag $1" $1 && git push origin main $1
}

BRANCHES() {
  git branch -l | grep -v "^\*"| fzf-tmux --multi | awk "{print \$1}"
}

deletebranch() {
  git branch -D "$(BRANCHES)"
}
# deletetag 1.0.0
deletetag() {
	git push origin :$1 && git tag -d $1
}
