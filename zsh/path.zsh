SYSTEM_PATH=${PATH}
unset PATH

PATH=~/bin
PATH=${PATH}:${GOROOT}/bin
PATH=${PATH}:${GOBIN}
PATH=${PATH}:${GOPATH}/bin
PATH=${PATH}:${GNU_BIN} // needs to be before brew
PATH=${PATH}:${BREWPATH}
PATH=${PATH}:${CDPATH}
PATH=${PATH}:${MONGOPATH}
PATH=${PATH}:${TEX}
PATH=${PATH}:/usr/local/bin
PATH=${PATH}:/usr/local/sbin
PATH=${PATH}:/usr/bin
PATH=${PATH}:/usr/sbin
PATH=${PATH}:/bin
PATH=${PATH}:/sbin

export PATH
