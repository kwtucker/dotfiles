SYSTEM_PATH=${PATH}
unset PATH

PATH=~/bin
PATH=${PATH}:${GOROOT}/bin
PATH=${PATH}:${GOBIN}
PATH=${PATH}:${GOPATH}/bin
PATH=${PATH}:${CDPATH}
PATH=${PATH}:${GEM_HOME}
PATH=${PATH}:${GNU_BIN} 
PATH=${PATH}:${TEX}
PATH=${PATH}:${HOME}/.cargo/bin
PATH=${PATH}:/opt/homebrew/bin
PATH=${PATH}:/opt/homebrew/sbin
PATH=${PATH}:${HOME}/.asdf/shims
PATH=${PATH}:${HOME}/.local/bin
PATH=${PATH}:/usr/local/bin
PATH=${PATH}:/usr/local/sbin
PATH=${PATH}:/usr/bin
PATH=${PATH}:/usr/sbin
PATH=${PATH}:/bin
PATH=${PATH}:/sbin

export PATH
