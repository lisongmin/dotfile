#!/usr/bin/env bash

_dir=$(realpath `dirname $0`)
source ${_dir}/.link_lib

# windows manager
link qtile ~/.config/qtile
link {qtile,~/.config/autorandr/postswitch.d}/restart-qtile-on-screen-changed.sh

# vim relative
link flake8 ~/.config/flake8
link flake8 ~/.config/pycodestyle
link _ctags ~/.ctags

# tmux
if [ ! -d ~/.tmux/plugins/tpm ] ; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi
link _tmux.conf ~/.tmux.conf

# zsh
link _zshrc ~/.zshrc
link {_,~/.}p10k.zsh

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

# terminal
link {_,~/.}config/termite/config

# music
systemctl --user enable xmms2d.service

# xidlehook
link {_,~/.}config/systemd/user/xidlehook.service
systemctl --user enable xidlehook

# gradle
link {,~/}.gradle/init.gradle
link {,~/}.gradle/gradle.properties

# bin
link {,~/.local/}bin/pik
link {,~/.local/}bin/.my_proxy

