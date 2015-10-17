#!/usr/bin/env bash

function git_update()
{
    local github=https://github.com/$1
    local dist=~/.vim/bundle/$(basename $1)
    if [ ! -d "$dist" ];then
        git clone "$github" "$dist"
    else
        cd "$dist"
        git pull
        cd -
    fi
}

if [ ! -d ~/.vim/bundle ];then
    mkdir -p ~/.vim/bundle
fi

git_update rust-lang/rust
git_update phildawes/racer
cd ~/.vim/bundle/racer
cargo build --release
cd -

git_update VundleVim/Vundle.vim
vim +PluginInstall +qall

# packages [boost clang cmake python2] are needed.
cd ~/.vim/bundle/YouCompleteMe
python2 ./install.py --clang-completer --system-libclang --system-boost
cd -
