#!/usr/bin/env bash

if [ ! -d ~/.config/nvim ];then
    mkdir -p ~/.config/nvim
fi
ln -sf ~/dotfile/nvim.vim ~/.config/nvim/init.vim

if [ ! -d ~/.local/share/nvim/plugged ];then
    mkdir -p ~/.local/share/nvim/plugged
fi

curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

nvim +PlugInstall +qall

# ======================
# { rust support.
# ======================
pacman -Q rustup
if [ $? -ne 0 ];then
    sudo pacman -S rustup rustfmt
fi

rustup update nightly && rustup default nightly
rustup component add rls-preview --toolchain nightly
rustup component add rust-analysis --toolchain nightly
rustup component add rust-src --toolchain nightly
# ======================
# } rust support end.
# ======================
