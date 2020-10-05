#!/usr/bin/env bash

_dir=$(realpath `dirname $0`)
source ${_dir}/../.link_lib

link {,/}etc/udev/rules.d/50-suspend-on-low-power.rules
link {,/}usr/local/bin/notify-me.sh
link {,/}usr/local/bin/notify-sound.sh
