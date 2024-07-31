import "../utils/mount.just"

play playlist="all": mount_family mpd_daemon
  mpc load "{{ playlist }}" > /dev/null
  mpc repeat on > /dev/null
  mpc random on > /dev/null
  mpc play > /dev/null

[private]
mpd_daemon:
  systemctl --user start mpd.socket
