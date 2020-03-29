# movetag 1.0.0
function movetaghead() {
	git push origin :$1 && git tag -fa -m "moving tag $1" $1 && git push origin master $1
}

# deletetag 1.0.0
function deletetag() {
	git push origin :$1 && git tag -d $1
}
