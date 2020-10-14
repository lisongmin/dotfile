#!/usr/bin/env bash

_dir=$(realpath `dirname $0`)
source ${_dir}/.link_lib

install_language_tools()
{
    # ======================
    # some plugins depend on python-neovim
    # ======================
    sudo pacman -S --needed --noconfirm python-neovim

    # ======================
    # { html/css/js/ts support.
    # ======================
    sudo pacman -S --needed --noconfirm yarn eslint tidy
    # install typescript for tsserver
    yarn global add typescript csslint
    # ======================
    # } html/css/js/ts support.
    # ======================

    # ======================
    # { yaml support.
    # ======================
    sudo pacman -S --needed --noconfirm yamllint
    # ======================
    # } yaml support.
    # ======================

    # ======================
    # { xml support.
    # ======================
    # xmllint
    sudo pacman -S --needed --noconfirm libxml2
    # ======================
    # } xml support.
    # ======================

    # ======================
    # { json support.
    # ======================
    sudo pacman -S --needed --noconfirm prettier
    # ======================
    # } json support.
    # ======================

    # ======================
    # { bash support.
    # ======================
    sudo pacman -S --needed --noconfirm shfmt
    yarn global add bash-language-server
    # ======================
    # } bash support.
    # ======================

    # ======================
    # { c/c++ support.
    # ======================
    sudo pacman -S --needed --noconfirm clang ccls-git flawfinder cppcheck
    # ======================
    # } c/c++ support.
    # ======================

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

    # ======================
    # { python support.
    # ======================
    sudo pacman -S --needed --noconfirm python-language-server python-pip flake8 autopep8 python-pylint
    # ======================
    # } python support end.
    # ======================

    # ======================
    # { vim script lint support
    pip install --user vim-vint
    # } vim script lint support
    # ======================

    # ======================
    # { go support
    sudo pacman -S --needed --noconfirm gopls
    # } go support
    # ======================
}

init_vim()
{
    link _vimrc ~/.vimrc
    link asynctask.ini ~/.vim/tasks.ini

    if [ ! -e ~/.vim/autoload/plug.vim ];then
        curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    fi

    vim +PlugInstall +qall
}

init_nvim()
{
    link _vimrc ~/.config/nvim/init.vim
    link asynctask.ini ~/.config/nvim/tasks.ini

    if [ ! -e ~/.local/share/nvim/site/autoload/plug.vim ] ; then
        if [ -e ~/.vim/autoload/plug.vim ];then
            link ~/.vim/autoload/plug.vim ~/.local/share/nvim/site/autoload/plug.vim
        else
            curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
                https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        fi
    fi

    nvim +PlugInstall +qall
}

install_language_tools
init_vim
init_nvim
