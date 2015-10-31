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

link $_dir/qtile ~/.config/qtile
link $_dir/xmonad ~/.xmonad
link $_dir/flake8 ~/.config/flake8

link $_dir/_vimrc ~/.vimrc
$_dir/init_vimrc.sh

link $_dir/_tmux.conf ~/.tmux.conf
link $_dir/_tmux-powerlinerc ~/.tmux-powerlinerc

link $_dir/_zshrc ~/.zshrc
