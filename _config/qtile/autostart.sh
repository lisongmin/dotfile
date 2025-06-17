#!/usr/bin/env bash

echo "$(date -Is) Starting user autostart script ..."

run-daemon() {
  program="$1"
  shift # Remove first argument (program name)
  exec_path=$(which "$program")
  if [ -e "$exec_path" ]; then
    pgrep -U "$USER" "^$program$"
    if [ $? -ne 0 ]; then
      echo "$(date -Is) Running daemon $program ..."
      "$exec_path" "$@" &
    fi
  fi
}

systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP

# disable beep
xset -b

# autorandr do not support wayland yet
autorandr --change

systemctl --user start dunst

run-daemon picom -b
run-daemon fcitx5
run-daemon firefox
run-daemon chromium
run-daemon Telegram
# run-daemon thunderbird
# run-daemon osdlyrics
# run-daemon element-desktop

echo "$(date -Is) User autostart script finished."
