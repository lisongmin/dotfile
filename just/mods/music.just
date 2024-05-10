import "../utils/mount.just"

play playlist="all": mount_family
  mpc load "{{ playlist }}" > /dev/null
  mpc repeat on > /dev/null
  mpc random on > /dev/null
  mpc play > /dev/null
