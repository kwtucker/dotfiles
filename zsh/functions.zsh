function up() {
  cd .. && find . -maxdepth 1 -type f -exec ls -l {} \; | awk '{print $9}'
}

# OSX stuffs
if [ "$(uname -s)" = "Darwin" ]; then
  alias showfiles="defaults write com.apple.finder AppleShowAllFiles TRUE; killall Finder"
  alias hidefiles="defaults write com.apple.finder AppleShowAllFiles FALSE; killall Finder"
  alias fixow='/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -kill -r -domain local -domain user;killall Finder;echo "Open With has been rebuilt, Finder will relaunch"'
fi

function show_colors() {
  for code in {000..255}; do print -P -- "$code: %F{$code}Test%f"; done
}

