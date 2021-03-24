#!/usr/bin/env bash

_dir=$(realpath `dirname $0`)
source ${_dir}/.link_lib

# python linters
link {_,~/.}config/flake8
link {_,~/.}config/pycodestyle
link {_,~/.}pylintrc

# vim relative
link {_,~/.}ctags

# tmux
if [ ! -d ~/.tmux/plugins/tpm ] ; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi
link {_,~/.}tmux.conf

# zsh
link {_,~/.}zshrc
link {_,~/.}p10k.zsh
link {_,~/.}remote_p10k.zsh

# pip
link pip.conf ~/.pip/pip.conf
link {_,~/.}pydistutils.cfg

# cargo
link _cargo ~/.cargo/config

# npm
link _npmrc ~/.npmrc

# dunst
link {_,~/.}config/dunst/dunstrc

# ccache
link _ccache ~/.ccache

# fontconfig
link {_,~/.}config/fontconfig

# gradle
link {,~/}.gradle/init.gradle
link {,~/}.gradle/gradle.properties

# windows manager
link qtile ~/.config/qtile
link {qtile,~/.config/autorandr/postswitch.d}/restart-qtile-on-screen-changed.sh

# xidlehook
link {_,~/.}config/systemd/user/xidlehook.service

# terminal
link {_,~/.}config/termite/config

# build arch package in chroot
link {_,~/.}local/bin/buildpkg
