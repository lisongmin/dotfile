
set working-directory := "../.."
set unstable := true

src_dir := justfile_directory()
home := env("HOME")

config target: && \
  (link (src_dir / "_config" / target) (home / '.config' / target))

@list-config:
  ls _config/ | grep -v "\.back$"

[script('bash')]
config-all:
  for f in $(ls _config/); do
      echo "Link config $f"
      just -f "{{ justfile() }}" link config "$f"
  done

[private, script('bash')]
link src target sudo="":
  if [ ! -e "{{ src }}" ];then
      echo "<warn> source [{{ src }}] not exists"
      exit 1
  fi

  if [ -e "{{ target }}" -a ! -L "{{ target }}" ]; then
      {{ sudo }} rm -rf "{{ target }}"
  fi

  target_dir="{{ parent_directory(target) }}"
  if [ ! -e "$target_dir" ];then
      {{ sudo }} mkdir -p "$target_dir"
  fi

  if [ ! -e "{{ target }}" ]; then
      {{ sudo }} ln -sf "{{ src }}" "{{ target }}"
  fi
