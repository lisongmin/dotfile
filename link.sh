#!/usr/bin/env bash

_dir=$(realpath `dirname $0`)
source ${_dir}/.link_lib

# windows manager
link qtile ~/.config/qtile

# vim relative
link flake8 ~/.config/flake8
link flake8 ~/.config/pycodestyle
link _vimrc ~/.vimrc
link _ctags ~/.ctags
link coc-settings.json ~/.vim/coc-settings.json
link coc-settings.json ~/.config/nvim/coc-settings.json

# tmux
if [ ! -d ~/.tmux/plugins/tpm ] ; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi
link _tmux.conf ~/.tmux.conf

# zsh
link _zshrc ~/.zshrc

# pip
link pip.conf ~/.pip/pip.conf
link {_,~/.}pydistutils.cfg

# cargo
link _cargo ~/.cargo/config

# npm
link _npmrc ~/.npmrc

# dunst
link dunstrc ~/.config/dunst/dunstrc

# ccache
link _ccache ~/.ccache

# fontconfig
link _config/fontconfig ~/.config/fontconfig

# terminal
link _config/termite/config ~/.config/termite/config

# music
systemctl --user enable xmms2d.service

# gradle
link {,~/}.gradle/init.gradle
link {,~/}.gradle/gradle.properties

# bin
link {,~/.local/}bin/pik
link {,~/.local/}bin/.my_proxy

