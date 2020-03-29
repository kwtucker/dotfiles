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
		notesB ; rm -rf ~/{.whalebyte,.ssh,go/src}
		return
	fi
}


function leave() {
	cleanenv	
}


function helm-toggle() {
    if [ -z "$1" ]; then
        echo "helm client and Tiller (server side) versions always must match. Simply toggle between different Helm versions installed by brew".
        echo
        echo "Usage: helm-toggle <Helm version>"
        echo
        echo "installed helm versions are:"
        brew info --json=v1  kubernetes-helm | jq -c '.[].installed[].version'
				echo "current helm version is:"
        brew info --json=v1  kubernetes-helm | jq '.[].linked_keg'
    else
        brew switch kubernetes-helm $1 > /dev/null # no appropriate error handling here if someone sets something silly
    fi
}



# -- MISC ------------------
#
# turn hidden files on/off in Finder
function hiddenOn() { defaults write com.apple.Finder AppleShowAllFiles YES ; }
function hiddenOff() { defaults write com.apple.Finder AppleShowAllFiles NO ; }

# myIP address
function myip() {
  ifconfig lo0 | grep 'inet ' | sed -e 's/:/ /' | awk '{print "lo0       : " $2}'
  ifconfig en0 | grep 'inet ' | sed -e 's/:/ /' | awk '{print "en0 (IPv4): " $2 " " $3 " " $4 " " $5 " " $6}'
  ifconfig en0 | grep 'inet6 ' | sed -e 's/ / /' | awk '{print "en0 (IPv6): " $2 " " $3 " " $4 " " $5 " " $6}'
  ifconfig en1 | grep 'inet ' | sed -e 's/:/ /' | awk '{print "en1 (IPv4): " $2 " " $3 " " $4 " " $5 " " $6}'
  ifconfig en1 | grep 'inet6 ' | sed -e 's/ / /' | awk '{print "en1 (IPv6): " $2 " " $3 " " $4 " " $5 " " $6}'
}

# function colors() {
# 	for i in {0..255}; do
# 			printf "\x1b[38;5;${i}mcolour${i}\x1b[0m\n"
# 	done
# }

