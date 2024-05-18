

# set ".j" alias for my own justfile
[no-cd]
install: alias-just alias-j

[no-cd,private]
alias-just:
  #!/usr/bin/env bash
  if [ -e ~/.zshrc ]; then
    grep -q "alias just=" ~/.zshrc
    if [ $? -ne 0 ]; then
      echo "alias just='just --unstable'" >> ~/.zshrc
    fi
  fi

  if [ -e ~/.bashrc ]; then
    grep -q "alias just=" ~/.bashrc
    if [ $? -ne 0 ]; then
      echo "alias just='just --unstable'" >> ~/.bashrc
    fi
  fi

[no-cd,private]
alias-j:
  #!/usr/bin/env bash

  justfile="{{ invocation_directory() / "Justfile" }}"
  if [ -e ~/.zshrc ]; then
    grep -q "alias [.]j=" ~/.zshrc
    if [ $? -ne 0 ]; then
      echo "alias .j='just --justfile ${justfile} --working-directory .'" >> ~/.zshrc
    fi
  fi

  if [ -e ~/.bashrc ]; then
    grep -q "alias [.]j=" ~/.bashrc
    if [ $? -ne 0 ]; then
      echo "alias .j='just --justfile ${justfile} --working-directory .'" >> ~/.bashrc
    fi
  fi
