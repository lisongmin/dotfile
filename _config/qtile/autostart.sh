#!/usr/bin/env bash

ime=$(which fcitx5 || which fcitx)
if [ -e "$ime" ]; then
  $ime &
fi

pgrep -U "$USER" '^xfce4-screensaver$'
if [ $? -ne 0 ]; then
  xfce4-screensaver &
fi

systemctl --user start dunst

autorandr --change

# disable beep
xset -b
picom -b

pgrep -U "$USER" '^firefox$'
if [ $? -ne 0 ]; then
  firefox &
fi

pgrep -U "$USER" '^tor-browser$'
if [ $? -ne 0 ]; then
  tor-browser &
fi

pgrep -U "$USER" '^chromium$'
if [ $? -ne 0 ]; then
  chromium &
fi

# pgrep -U "$USER" '^thunderbird$'
# if [ $? -ne 0 ];then
#     thunderbird&
# fi

# pgrep osdlyrics
# if [ $? -ne 0 ]; then
#    osdlyrics&
# fi

which telegram-desktop
if [ $? -eq 0 ]; then
  pgrep -U "$USER" telegram
  if [ $? -ne 0 ]; then
    telegram-desktop &
  fi
fi

which element-desktop
if [ $? -eq 0 ]; then
  pgrep -U "$USER" element-desktop
  if [ $? -ne 0 ]; then
    element-desktop &
  fi
fi

if which nextcloud; then
  if ! pgrep -U "$USER" nextcloud; then
    nextcloud &
  fi
fi
