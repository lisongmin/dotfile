#!/usr/bin/env bash

if [ ! -d ~/.vim/bundle ];then
    mkdir -p ~/.vim/bundle
fi

curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

vim +PlugInstall +qall

echo "You should download rust source to /usr/local/src/rust"
