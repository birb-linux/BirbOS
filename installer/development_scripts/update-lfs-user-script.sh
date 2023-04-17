#!/bin/sh


# This script copies the ../lfs-user-bootstrap.sh script into
# the home directory of the LFS user and updates the file
# permissions
[ "$(whoami)" != "root" ] && echo "This script needs to be run as the root user" && exit 1
EXEC_PATH=$(dirname $0)
cp -v $EXEC_PATH/../lfs-user-bootstrap.sh /home/lfs/
chown -v lfs:lfs /home/lfs/lfs-user-bootstrap.sh
