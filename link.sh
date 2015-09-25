#!/usr/bin/env bash

_dir=$(realpath `dirname $0`)

ln -sf $_dir/qtile ~/.config/qtile
ln -sf $_dir/xmonad ~/.xmonad

ln -sf $_dir/flake8 ~/.config/flake8
