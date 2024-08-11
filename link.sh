#!/usr/bin/env bash

_dir=$(realpath $(dirname $0))
source ${_dir}/.link_lib

# python linters
link {_,~/.}pylintrc
link {_,~/.}xprofile

# vim relative
link {_,~/.}ctags

# tmux
if [ ! -d ~/.tmux/plugins/tpm ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi
link {_,~/.}tmux.conf

# zsh
link {_,~/.}zshrc
link {_,~/.}p10k.zsh
link {_,~/.}remote_p10k.zsh

# pip
link pip.conf ~/.pip/pip.conf

# cargo
link _cargo ~/.cargo/config

# npm
link _npmrc ~/.npmrc

# build arch package in chroot
link {_,~/.}local/bin/buildpkg
