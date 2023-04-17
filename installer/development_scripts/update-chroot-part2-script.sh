#!/bin/sh

export LFS=/mnt/lfs

# This script copies the ../chroot-install-part-2.sh script into
# the root of the LFS chroot environment and sets the correct permissions
[ "$(whoami)" != "root" ] && echo "This script needs to be run as the root user" && exit 1
EXEC_PATH=$(dirname $0)
cp -v $EXEC_PATH/../chroot-install-part-2.sh $LFS/
chown -v root:root $LFS/chroot-install-part-2.sh
