#!/usr/bin/env bash

_dir=$(realpath $(dirname $0))
source ${_dir}/.link_lib

# python linters
link {_,~/.}config/flake8
link {_,~/.}config/pycodestyle
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

# dunst
link {_,~/.}config/dunst/dunstrc

# fontconfig
link {_,~/.}config/fontconfig

# windows manager
link qtile ~/.config/qtile

# dingtalk
# link {_,~/.}config/systemd/user/dingtalk.service

# terminal
link {_,~/.}config/alacritty

# build arch package in chroot
link {_,~/.}local/bin/buildpkg

# flameshot
link {_,~/.}config/flameshot
