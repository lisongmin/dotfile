
set unstable := true

rime_lmdg_version := "v2n3"
rime_lmdg_name := "amz-" + rime_lmdg_version + "m1-zh-hans"

# Instaall input method fcitx5
[no-cd]
input-method: fcitx5

[no-cd, private, script]
pkg +pkgs:
  echo "Install package {{ pkgs }} ..."
  sudo pacman -S --needed --noconfirm {{ pkgs }}

[no-cd, private]
fcitx5: (pkg "fcitx5-im" "fcitx5-rime") rime-ice

[no-cd, private]
rime-ice: (pkg "rime-ice-pinyin-git") rime-lmdg rime-ice-config

[no-cd, private, script]
rime-lmdg:
  echo "Install rime-lmdg {{ rime_lmdg_name }} ..."
  cd ~/.local/share/fcitx5/rime
  curl -s -C - -O https://github.com/amzxyz/RIME-LMDG/releases/download/{{ rime_lmdg_version }}/{{ rime_lmdg_name }}.gram

[no-cd, private, script]
rime-ice-config:
  echo "Config rime ice ..."
  cd ~/.local/share/fcitx5/rime
  ln -sf {{ justfile_directory() / "_local/share/fcitx5/rime/default.custom.yaml" }} default.custom.yaml
  sed -i 's/\(\s\+language:\)\s\+.*/\1 {{ rime_lmdg_name }}/g' default.custom.yaml
  
