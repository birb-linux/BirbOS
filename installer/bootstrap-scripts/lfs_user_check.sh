#!/bin/bash

# This script makes sure that we are operating as the
# LFS user and the mountpoint has been set correctly
echo "Making sure that the LFS user works as expected..."

cd ~ || exit 1
source ~/.bashrc

[ "$(whoami)" != "lfs" ] && echo "We aren't logged in as the LFS user!" && exit 1
[ "$LFS" != "/mnt/lfs" ] && echo "Incorrect \$LFS variable doesn't point to /mnt/lfs !" && exit 2

exit 0
