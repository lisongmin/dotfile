
set unstable := true

# set ".j" alias for my own justfile
[no-cd]
install: alias-j

[no-cd,private,script('bash')]
alias-j:
  if [ -e ~/.zshrc ]; then
    grep -q "alias [.]j=" ~/.zshrc
    if [ $? -ne 0 ]; then
      echo "alias .j='just -f "{{ justfile() }}" --working-directory .'" >> ~/.zshrc
    fi
  fi

  if [ -e ~/.bashrc ]; then
    grep -q "alias [.]j=" ~/.bashrc
    if [ $? -ne 0 ]; then
      echo "alias .j='just -f "{{ justfile() }}" --working-directory .'" >> ~/.bashrc
    fi
  fi
