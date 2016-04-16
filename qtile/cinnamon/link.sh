#!/bin/bash

_dir=$(realpath `dirname $0`)

ln -sf $_dir/qtile-cinnamon.desktop /usr/share/xsessions/qtile-cinnamon.desktop
ln -sf $_dir/qtile.session /usr/share/cinnamon-session/sessions/qtile.session
ln -sf $_dir/qtile.desktop /usr/share/applications/qtile.desktop
ln -sf $_dir/qtile-cinnamon_badge-symbolic.svg /usr/share/icons/hicolor/scalable/places/qtile-cinnamon_badge-symbolic.svg
