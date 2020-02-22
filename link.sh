#!/usr/bin/env bash

_dir=$(realpath `dirname $0`)

link()
{
    local source_file="$_dir/$1"
    if [ ! -e "$source_file" ];then
        echo "<warn> source [$source_file] not exists"
        return 1
    fi

    local target_link="$2"
    if [ -e "$target_link" -a ! -L "$target_link" ]; then
        rm -rf "$target_link"
    fi

    local target_dir
    target_dir=$(dirname "$target_link")
    if [ ! -e "$target_dir" ];then
        mkdir -p "$target_dir"
    fi

    if [ ! -e "$target_link" ]; then
        ln -s "$source_file" "$target_link"
    fi
}

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

# bin
link bin/pik ~/.local/bin/pik
