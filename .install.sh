#!/bin/bash

## manual steps
# install command line tools (just try to run git and it'll ask you)
# Set caps lock to escape

function main() {
  make_directories
  clone_repos
  create_symlinks
  brew_install
  setup_yadr
  setup_zprezto
}

function make_directories() {
  for dir in $HOME/src/github.com/jetpks $HOME/tmp $HOME/bin; do
    mkdir -p $dir
  done
}

# TODO derive the correct paths
function clone_repos() {
  for repo in presto yadr dotfiles; do
    pushd $HOME/src/github.com/jetpks
    git clone "https://github.com/jetpks/${repo}.git"
    popd
  done
}

function create_symlinks() {
  local prefix=$HOME/src/github.com/jetpks
  ln -s $prefix/yadr $HOME/.yadr
  ln -s $prefix/dotfiles $HOME/.dotfiles
  ln -s $prefix/presto $HOME/.zprezto
}

function brew_install() {
  if ! which brew; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  fi

  pushd $HOME/.dotfiles
  brew update
  brew tap homebrew/bundle
  brew bundle
  popd
}

function setup_yadr() {
  pushd $HOME/src/github.com/jetpks/yadr
  ASK=true rake install
  popd
}

function setup_zprezto() {
  pushd $HOME/.zprezto
  git submodule update --init --recursive
  for runcom in zlogin zlogout zpreztorc zprofile zshenv zshrc; do
    ln -s "$HOME/.zprezto/runcoms/${runcom}" "$HOME/.${runcom}"
  done
  popd
}

main


