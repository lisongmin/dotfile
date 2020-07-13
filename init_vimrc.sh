#!/usr/bin/env bash

sudo pacman -S --needed --noconfirm yarn \
    fzf \
    flawfinder \
    clang \
    cppcheck \
    eslint \
    prettier \
    tidy \
    alex \
    yamllint \
    libxml2 \
    python-neovim \
    ccls-git \
    flake8 autopep8 python-pylint

yarn global add bash-language-server \
    javascript-typescript-langserver \
    csslint \
    vim-node-rpc


pip install --user python-language-server \
    vim-vint

if [ ! -d ~/.vim/bundle ];then
    mkdir -p ~/.vim/bundle
fi

if [ ! -e ~/.vim/autoload/plug.vim ];then
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

vim +PlugInstall +qall
vim "+CocInstall coc-css coc-emoji coc-html coc-java coc-json coc-python coc-rls coc-tsserver coc-ultisnips coc-yaml"
