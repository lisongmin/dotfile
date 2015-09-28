#!/usr/bin/env bash

xset -b
compton -b
/usr/bin/feh --bg-scale ~/dotfile/wallpaper/jzbq.jpeg&

fcitx&

xautolock -time 10 -locker sxlock -killtime 60 -killer "systemctl suspend"&
xss-lock -- /usr/bin/sxlock&

xfce4-terminal&
tilda -h&

firefox&
thunderbird&

telegram&
