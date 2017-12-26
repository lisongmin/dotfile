#!/usr/bin/env bash

_dir=$(realpath `dirname $0`)

link()
{
    if [ -e "$2" -a ! -L "$2" ]; then
        rm -rf "$2"
    fi
    if [ ! -e "$2" ]; then
        ln -s "$1" "$2"
    fi
}

# windows manager
link $_dir/qtile ~/.config/qtile
link $_dir/xmonad ~/.xmonad

# vim relative
link $_dir/flake8 ~/.config/flake8
link $_dir/flake8 ~/.config/pycodestyle
link $_dir/_vimrc ~/.vimrc
link $_dir/_ctags ~/.ctags
link $_dir/.ycm_extra_conf.py ~/.vim/.ycm_extra_conf.py

# tmux
if [ ! -d ~/.tmux/plugins/tpm ] ; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi
link $_dir/_tmux.conf ~/.tmux.conf
link $_dir/_tmux-powerlinerc ~/.tmux-powerlinerc

# zsh
link $_dir/_zshrc ~/.zshrc

# pip
mkdir -p ~/.pip
link $_dir/pip.conf ~/.pip/pip.conf

# cargo
if [ ! -e ~/.cargo ];then
    mkdir -p ~/.cargo
fi
link $_dir/_cargo ~/.cargo/config

# npm
link $_dir/_npmrc ~/.npmrc
