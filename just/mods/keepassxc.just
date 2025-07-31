set unstable

import "../utils/mount.just"

[no-cd,private]
keepassxc: backup_credential
  keepassxc

[no-cd, private, script("bash")]
@backup_credential: mount_credential
  mkdir -p ~/.credentials-backup
  
  # Check if directory exists and is not empty
  if [ ! -d ~/.credentials ] || [ -z "$(ls -A ~/.credentials)" ]; then
    echo "No .credentials directory or directory is empty"
    exit 0
  fi

  # Process each .kdbx file (including hidden files) in .credentials
  shopt -s nullglob dotglob
  for kdbx_file in ~/.credentials/*.kdbx; do
    if [ -f "$kdbx_file" ]; then
      filename=$(basename "$kdbx_file")
      backup_file=~/.credentials-backup/$filename
      
      # If backup doesn't exist, just copy it
      if [ ! -f "$backup_file" ]; then
        echo "Creating new backup for $filename"
        cp -a "$kdbx_file" "$backup_file"
      else
        if [ -f "$backup_file.old" ] && [ "$backup_file.old" -nt "$kdbx_file" ]; then
          echo "Backup for $filename is already up to date, skipping merge"
          continue
        fi
        # Create backup of existing backup file
        echo "Merging changes for $filename"
        cp -a "$backup_file" "$backup_file.old"
        keepassxc-cli merge -s "$backup_file" "$kdbx_file"  || exit $?
      fi
    fi
  done
  shopt -u nullglob dotglob
