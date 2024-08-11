
set dotenv-load := true
set unstable := true

mod music "just/mods/music.just"
mod self "just/mods/self.just"
mod keepassxc "just/mods/keepassxc.just"
mod link "just/mods/link.just"

[script]
list:
  just -l --list-submodules -f "{{ justfile() }}"
