#!/usr/bin/env bash

# install from aur
# sudo pacman -S --needed --noconfirm pikaur

# shell
# Install bash-completion for zsh-bash-completions-fallback
sudo pacman -S --needed --noconfirm zsh tmux bash-completion
# colorful the `ls` command
sudo pacman -S --needed --noconfirm vivid

# text editor
sudo pacman -S --needed --noconfirm neovim vim

# translate
sudo pacman -S --needed --noconfirm translate-shell

if [ "$1" = "gui" ]; then
  # terminals
  sudo pacman -S --needed --noconfirm termite xfce4-terminal
  # browser
  sudo pacman -S --needed --noconfirm firefox

  # window manager
  sudo pacman -S --needed --noconfirm qtile python-pywlroots

  # Since I use wm without DE, I need
  # some utils to perform the functions of DE
  # 1. screen lock, sleep, hibernate on idle.
  # pikaur -S --needed --noconfirm xidlehook
  # systemctl --user enable xidlehook
  # 2. dbus notification
  # sudo pacman -S --needed --noconfirm dunst
  # 3. powersave on laptop
  sudo pacman -S --needed --noconfirm tlp
  # 4. screen shot
  sudo pacman -S --needed --noconfirm flameshot
  # 5. volume coordinate
  # sudo pacman -S --needed --noconfirm pulseaudio-alsa pulseaudio-bluetooth
  # 6. wallpaper
  sudo pacman -S --needed --noconfirm feh
  # 7. brightness
  sudo pacman -S --needed --noconfirm brightnessctl
  # 8. file manager
  sudo pacman -S --needed --noconfirm nemo
  # 9. input method
  sudo pacman -S --needed --noconfirm fcitx5-im fcitx5-rime

  # 10. music
  sudo pacman -S --needed --noconfirm xmms2
  # systemctl --user enable xmms2d.service
  # 11. video
  sudo pacman -S --needed --noconfirm mpv
  # 12. picture
  sudo pacman -S --needed --noconfirm shotwell eog
  # 13. wireless
  sudo pacman -S --needed --noconfirm iwd
fi
