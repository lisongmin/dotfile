
set working-directory := "../.."
set unstable := true

src_dir := justfile_directory()
home := env("HOME")

all: \
  config-all \
  home-all

config target: && \
  (link (src_dir / "_config" / target) (home / '.config' / target))

@config-list:
  ls -A _config/ | grep -v "\.back$"

# link all config files to ~/.config
[script('bash')]
config-all:
  for f in $(ls -A _config/ | grep -v "\.back$"); do
      just -f "{{ justfile() }}" link config "$f"
  done

[script('bash')]
home target:
  just -f "{{ justfile() }}" link \
    link "{{ src_dir / '_home' / target }}" "{{ home / replace_regex(target, '^_', '.') }}"

@home-list:
  ls -A _home/ | grep -v "\.back$"

# link all home files to ~/
[script('bash')]
home-all:
  for f in $(ls -A _home/ | grep -v "\.back$"); do
      just -f "{{ justfile() }}" link home "$f"
  done

[private, script('bash')]
link src target sudo="":
  echo "Link {{ src }} to {{ target }}"
  if [ ! -e "{{ src }}" ];then
      echo "<warn> source [{{ src }}] not exists"
      exit 1
  fi

  if [ -e "{{ target }}" -a ! -L "{{ target }}" ]; then
      {{ sudo }} rm -rf "{{ target }}"
  fi

  # Remove broken link
  if [ ! -e "{{ target }}" -a -L "{{ target }}" ]; then
      {{ sudo }} rm -f "{{ target }}"
  fi

  target_dir="{{ parent_directory(target) }}"
  if [ ! -e "$target_dir" ];then
      {{ sudo }} mkdir -p "$target_dir"
  fi

  if [ ! -e "{{ target }}" ]; then
      {{ sudo }} ln -sf "{{ src }}" "{{ target }}"
  fi
