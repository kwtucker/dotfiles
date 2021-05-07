# -------------------------------------------------------------------
# Functions 
# -------------------------------------------------------------------

# Environment ------------------
#

function cleanenv() {
	echo -n "\nARE YOU SURE [N/y]: "
	read  selection
	echo
	
	if [[ $selection == '' || `echo "$selection" | awk '{print tolower($0)}'` == 'n' ]]; then
		return
	fi

	if [[ `echo "$selection" | awk '{print tolower($0)}'` == 'y' ]]; then
		notesB ; rm -rf ~/{.whalebyte,.ssh,go/src/github.com/kwtucker}
		return
	fi
}


function leave() {
	cleanenv	
}

# -- MISC ------------------
#

# OSX stuffs
if [ "$(uname -s)" = "Darwin" ]; then
  alias showfiles="defaults write com.apple.finder AppleShowAllFiles TRUE; killall Finder"
  alias hidefiles="defaults write com.apple.finder AppleShowAllFiles FALSE; killall Finder"
  alias fixow='/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -kill -r -domain local -domain user;killall Finder;echo "Open With has been rebuilt, Finder will relaunch"'
fi

# myIP address
function myip() {
  ifconfig lo0 | grep 'inet ' | sed -e 's/:/ /' | awk '{print "lo0       : " $2}'
  ifconfig en0 | grep 'inet ' | sed -e 's/:/ /' | awk '{print "en0 (IPv4): " $2 " " $3 " " $4 " " $5 " " $6}'
  ifconfig en0 | grep 'inet6 ' | sed -e 's/ / /' | awk '{print "en0 (IPv6): " $2 " " $3 " " $4 " " $5 " " $6}'
  ifconfig en1 | grep 'inet ' | sed -e 's/:/ /' | awk '{print "en1 (IPv4): " $2 " " $3 " " $4 " " $5 " " $6}'
  ifconfig en1 | grep 'inet6 ' | sed -e 's/ / /' | awk '{print "en1 (IPv6): " $2 " " $3 " " $4 " " $5 " " $6}'
}

function show_colors() {
  for code in {000..255}; do print -P -- "$code: %F{$code}Test%f"; done
}

