#!/usr/bin/env bash

_dir=$(realpath $(dirname $0))
source ${_dir}/.link_lib

# tmux
if [ ! -d ~/.tmux/plugins/tpm ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# pip
link pip.conf ~/.pip/pip.conf

# build arch package in chroot
link {_,~/.}local/bin/buildpkg
