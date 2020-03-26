#!/usr/bin/env bash

_dir=$(realpath `dirname $0`)
source ${_dir}/../.link_lib
#
link {,/etc/}pacman.d/mirrorlist
link {,/etc/}pacman.d/archlinuxcn
