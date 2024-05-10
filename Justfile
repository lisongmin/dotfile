
family_mount_point := env_var("HOME") + "/Family"

[no-cd, private]
@mount_point mountpoint:
  mkdir -p "{{ mountpoint }}"

[no-cd, private]
@mount mountpoint: (mount_point mountpoint)
  mount "{{ mountpoint }}"

music playlist="all": (mount family_mount_point)
  mpc load "{{ playlist }}" > /dev/null
  mpc repeat on > /dev/null
  mpc random on > /dev/null
  mpc play > /dev/null

# The self-install command will only run once and will add the alias to the
# user's shell configuration file. This will allow the user to run the
# command `.j` from any directory and it will use the Justfile in the current
# directory.
[private]
self-install:
  #!/usr/bin/env bash

  if [ -e ~/.zshrc ]; then
    grep -q "alias [.]j=" ~/.zshrc
    if [ $? -ne 0 ]; then
      echo "alias .j='just --justfile {{ invocation_directory() }}/Justfile --working-directory .'" >> ~/.zshrc
    fi
  fi

  if [ -e ~/.bashrc ]; then
    grep -q "alias [.]j=" ~/.bashrc
    if [ $? -ne 0 ]; then
      echo "alias .j='just --justfile {{ invocation_directory() }}/Justfile --working-directory .'" >> ~/.bashrc
    fi
  fi
