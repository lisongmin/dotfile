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
link $_dir/config ~/.mplayer/config