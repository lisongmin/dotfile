#!/bin/bash

move_subvolume()
{
    local src_subvol=$1
    local dest=$2
    local dest_subvol=$dest/$(basename $src_subvol)

    echo "move subvolume from $1 to $2 ..."

    btrfs property set -ts $src_subvol ro true || return 1
    btrfs send $src_subvol|btrfs receive $dest || return 2
    btrfs property set -ts $dest_subvol ro false || return 3
    btrfs subvolume delete $src_subvol

    return $?
}

move_subvolume $1 $2
