#!/usr/bin/env bash

xset -b
compton -b
/usr/bin/feh --bg-scale ~/dotfile/wallpaper/jzbq.jpeg&

fcitx&

xautolock -time 10 -locker sxlock -killtime 120 -killer "systemctl suspend"&
# xss-lock -- /usr/bin/sxlock&

tmux new-session -s term -d
tmux new-session -s tilda -d
tmux new-session -s work -c /work -d

xfce4-terminal -e "tmux attach-session -t term"&
tilda -h -c "tmux attach-session -t tilda"&

firefox&
thunderbird&

telegram&
