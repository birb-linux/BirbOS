#!/bin/bash

# This script isn't supposed to be used as part of the installation,
# but rather as an easy way to chroot into the BirbOS installation
# in-case there's something that needs to be fixed without booting
# into the installation

export LFS=/mnt/lfs

# Check if the partition is already mounted
LFS_MOUNTED_PARTITION="$(df | grep $LFS | awk '{print $1}')"
if [ -z "$LFS_MOUNTED_PARTITION" ]
then
	echo "BirbOS isn't mounted. Please mount it before running this script"
	exit 1
fi

mkdir -pv $LFS/{dev,proc,sys,run}

mount -v --bind /dev $LFS/dev
mount -v --bind /dev/pts $LFS/dev/pts
mount -vt proc proc $LFS/proc
mount -vt sysfs sysfs $LFS/sys
mount -vt tmpfs tmpfs $LFS/run

chroot "$LFS" /usr/bin/env -i HOME=/root TERM="$TERM" BIRB_CHROOT="yes" /bin/bash --login
