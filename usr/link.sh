#!/usr/bin/env bash

_dir=$(realpath `dirname $0`)
source ${_dir}/../.link_lib
#
link {,/usr/}share/xsessions/cinnamon-qtile.desktop
link {,/usr/}share/applications/qtile.desktop
link {,/usr/}share/cinnamon-session/sessions/qtile.session
