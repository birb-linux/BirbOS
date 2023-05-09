#!/bin/sh

# This script should be run after bootstrap.sh has finished
# and most of the temporary cross compiling toolchain has been
# compiled as the LFS user with the lfs-user-bootstrap.sh script

# If this variable isn't exported, the host distro will be in deep trouble
export LFS=/mnt/lfs

# Make sure that we are running as root
[ "$(whoami)" != "root" ] && echo "This script needs to be run as the root user" && exit 1

source ./installer-funcs.sh

prog_line "Changing $LFS file permissions from the LFS user to root"
chown -R root:root $LFS/{usr,lib,var,etc,bin,sbin,tools}
chown -R root:root $LFS/lib64
chown -R root:root $LFS/lib32
chown -R root:root $LFS/libx32

prog_line "Copying the chroot-install.sh script to $LFS"
cp -v ./chroot-install.sh $LFS/
cp -v ./chroot-install-part-{2..4}.sh $LFS/
chown root:root $LFS/chroot-install.sh
chown root:root $LFS/chroot-install-part-{2..4}.sh

prog_line "Copying all of the temporary tool installation scripts into $LFS/root"

# Make sure that the root directory exists
mkdir -p $LFS/root
chown root:root $LFS/root

cp -vr ./bootstrap-scripts $LFS/root/
chown -v -R root:root $LFS/root/bootstrap-scripts

cp -vr ./misc_installation_files $LFS/root/
chown -v -R root:root $LFS/root

prog_line "Preparing virtual kernel file systems"
mkdir -pv $LFS/{dev,proc,sys,run}

mount -v --bind /dev $LFS/dev
mount -v --bind /dev/pts $LFS/dev/pts
mount -vt proc proc $LFS/proc
mount -vt sysfs sysfs $LFS/sys
mount -vt tmpfs tmpfs $LFS/run

if [ -h $LFS/dev/shm ]; then
  mkdir -pv $LFS/$(readlink $LFS/dev/shm)
else
  mount -t tmpfs -o nosuid,nodev tmpfs $LFS/dev/shm
fi


prog_line "Starting the birb package manager setup"
./birb-setup.sh

prog_line "Entering the chroot environment"
echo "To continue with the installation in the chroot environment, run the 'chroot-install.sh' script located at the root directory"
chroot "$LFS" /usr/bin/env -i   \
    HOME=/root                  \
    TERM="$TERM"                \
    PS1='(BirbOS chroot) \u:\w\$ ' \
    PATH=/usr/bin:/usr/sbin:/usr/local/bin:/usr/python_bin \
    /bin/bash --login
