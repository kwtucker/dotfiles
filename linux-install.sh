#!/bin/bash

function install {
  which $1 &> /dev/null

  if [ $? -ne 0 ]; then
    echo "Installing: ${1}..."
    apt install $1
  else
    echo "Already installed: ${1}"
  fi
}

install build-essential
install procps
install curl
install file
install git
install gcc
install htop
install 1password
install timeshift
install neofetch
install alacritty
install zsh
