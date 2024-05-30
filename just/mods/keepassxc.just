import "../utils/mount.just"

[no-cd,private]
keepassxc: backup_credential
  keepassxc

[no-cd,private]
@backup_credential: mount_credential
  mkdir -p ~/.credentials-backup
  rsync -a ~/.credentials/ ~/.credentials-backup
