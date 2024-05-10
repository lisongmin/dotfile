

# set ".j" alias for my own justfile
[no-cd]
install:
  #!/usr/bin/env bash
  set -eo pipefail

  justfile="{{ invocation_directory() / "Justfile" }}"
  if [ -e ~/.zshrc ]; then
    grep -q "alias [.]j=" ~/.zshrc
    if [ $? -ne 0 ]; then
      echo "alias .j='just --unstable --justfile ${justfile} --working-directory .'" >> ~/.zshrc
    fi
  fi

  if [ -e ~/.bashrc ]; then
    grep -q "alias [.]j=" ~/.bashrc
    if [ $? -ne 0 ]; then
      echo "alias .j='just --unstable --justfile ${justfile} --working-directory .'" >> ~/.bashrc
    fi
  fi
