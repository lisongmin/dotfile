#!/usr/bin/env bash

if [ "$XDG_SESSION_DESKTOP" == "qtile" ]; then
    if [ -e ~/dotfile/wallpaper/family.jpeg ];then
        /usr/bin/feh --bg-scale ~/dotfile/wallpaper/family.jpeg&
    else
        /usr/bin/feh --bg-scale ~/dotfile/wallpaper/jzbq.jpeg&
    fi

    fcitx&

    xautolock -time 10 -locker sxlock -killtime 120 -killer "systemctl suspend"&
    # xss-lock -- /usr/bin/sxlock&
fi

# disable beep
xset -b
compton -b

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

which mattermost-desktop
if [ $? -eq 0 ];then
    pgrep -U "$USER" '^mattermost-desktop$'
    if [ $? -ne 0 ];then
         mattermost-desktop --proxy-server=socks5://127.0.0.1:10800 &
    fi
fi
