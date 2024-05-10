family_mount_point := env('MY_FAMILY_DIR', env("HOME") / "Family")

[no-cd, private]
@mount_point mountpoint:
  mkdir -p "{{ mountpoint }}"

[no-cd, private]
@mount mountpoint: (mount_point mountpoint)
  mount "{{ mountpoint }}"

[no-cd, private]
@mount_family: (mount family_mount_point)
