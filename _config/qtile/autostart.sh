#!/usr/bin/env bash

echo "$(date -Is) Starting user autostart script ..."

run-daemon() {
  program="$1"
  shift # Remove first argument (program name)

  exec_path=$(which "$program")
  if [ -e "$exec_path" ]; then
    # Use -f option if program name is longer than 15 characters
    if [ ${#program} -gt 15 ]; then
      pgrep -U "$USER" -f "\<$program\>"
    else
      pgrep -U "$USER" "^$program$"
    fi

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
# autorandr --change

systemctl --user start dunst

run-daemon picom -b
run-daemon fcitx5
run-daemon firefox
run-daemon chromium
run-daemon Telegram
# run-daemon thunderbird
# run-daemon osdlyrics
# run-daemon element-desktop

if [ -z "$WAYLAND_DISPLAY" ]; then
  run-daemon xfce4-screensaver
fi

echo "$(date -Is) User autostart script finished."
