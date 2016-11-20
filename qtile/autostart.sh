#!/usr/bin/env bash

if [ "$XDG_SESSION_DESKTOP" != "qtile-cinnamon" ]; then
    /usr/bin/setxkbmap -option "caps:swapescape"
    /usr/bin/feh --bg-scale ~/dotfile/wallpaper/jzbq.jpeg&

    fcitx&

    xautolock -time 10 -locker sxlock -killtime 120 -killer "systemctl suspend"&
    # xss-lock -- /usr/bin/sxlock&
fi

# disable beep
xset -b
compton -b

pgrep tmux
if [ $? -ne 0 ];then
    tmux new-session -d
    tmux new-session -s term -d
    tmux new-session -s tilda -d
    tmux new-session -s work -c /work -d
fi

xfce4-terminal -e "tmux attach-session -t term"&
tilda -h -c "tmux attach-session -t tilda"&

#pgrep firefox
#if [ $? -ne 0 ]; then
#    firefox&
#fi
# thunderbird&

#pgrep osdlyrics
#if [ $? -ne 0 ]; then
#    osdlyrics&
#fi

#telegram-desktop&
