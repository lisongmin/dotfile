#!/usr/bin/env bash

if [ -e ~/dotfile/wallpaper/family.jpeg ];then
    /usr/bin/feh --bg-scale ~/dotfile/wallpaper/family.jpeg&
else
    /usr/bin/feh --bg-scale ~/dotfile/wallpaper/jzbq.jpeg&
fi

ime=$(which fcitx5 || which fcitx)
if [ -e "$ime" ]; then
    $ime&
fi

pgrep -U "$USER" '^gnome-screensaver$'
if [ $? -ne 0 ];then
    gnome-screensaver&
fi

systemctl --user start dunst

# disable beep
xset -b
picom -b

pgrep -U "$USER" '^tmux$'
if [ $? -ne 0 ];then
    tmux new-session -d
    tmux new-session -s term -d
    tmux new-session -s work -c /work -d
    xfce4-terminal -e "tmux attach-session -t term"&
fi

pgrep -U "$USER" '^firefox$'
if [ $? -ne 0 ]; then
    firefox&
fi

pgrep -U "$USER" '^tor-browser$'
if [ $? -ne 0 ]; then
    tor-browser&
fi

pgrep -U "$USER" '^chromium$'
if [ $? -ne 0 ]; then
    chromium&
fi

pgrep -U "$USER" '^thunderbird$'
if [ $? -ne 0 ];then
    thunderbird&
fi

# pgrep osdlyrics
# if [ $? -ne 0 ]; then
#    osdlyrics&
# fi

which telegram-desktop
if [ $? -eq 0 ];then
    pgrep -U "$USER" telegram
    if [ $? -ne 0 ];then
        telegram-desktop&
    fi
fi

which element-desktop
if [ $? -eq 0 ];then
    pgrep -U "$USER" element-desktop
    if [ $? -ne 0 ];then
        element-desktop&
    fi
fi

which dingtalk
if [ $? -eq 0 ];then
    pgrep -U "$USER" '^dingtalk$'
    if [ $? -ne 0 ];then
        dingtalk&
    fi
fi
