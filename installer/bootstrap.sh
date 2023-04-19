#!/bin/bash

[ "$2" == "DEV_MODE" ] && DEV_MODE="enabled" && echo "Developer mode is enabled! All warnings will be skipped. Please be careful..."
read -p "Hit ENTER to continue ʕ •ᴥ•ʔ"

source ./installer-funcs.sh

# Make sure that we are running as root
[ "$(whoami)" != "root" ] && echo "This script needs to be run as the root user" && exit 1

[ -z "$1" ] && echo -e "You need to provide a path to the bootstrap configuration file.\nCheck the documentation for more information" && exit 1

# Make sure the given config file exists
[ -f "$1" ] || { echo "File [$1] not found" ; exit 1; }

# Source all of the variables from the config file
. $1

# Make sure that all of the required lines are in the config file
prog_line "Validating the config file"
check_setting()
{
	[ -n "${!1}" ] || echo "Setting [$1] wasn't found or was empty"
}
check_setting TARGET_PARTITION

prog_line "Running a version check"
VER_RESULT="$(./version-check.sh)"

# Check for any errors and quit if there are any
VER_ERRORS="$(echo "$VER_RESULT" | grep '^ERROR')"
if [ -n "$VER_ERRORS" ]
then
	echo "Can't continue with the setup!"
	echo "$VER_ERRORS"
fi

# Check for required programs
find_program()
{
	which $1 &>/dev/null || { echo "$1 not installed"; MISSING_PROGRAMS="$MISSING_PROGRAMS;$1"; }
}
find_program wget
find_program git
find_program curl
find_program mkfs.ext4

[ -n "$MISSING_PROGRAMS" ] && echo "There were missing programs! Please install them before continuing with the installation..." && exit 1

prog_line "Preparing the filesystem for installation"
if [ -z $DEV_MODE ]
then
	echo -e "\n!!! WARNING !!!"
	echo "If you continue, the selected partition [$TARGET_PARTITION] will be totally wiped and overwritten!"
	echo -e "You have been warned.\n"
	read -p "Please write 'i have read the warning' to continue with the installation: " WARNING_READ
	if [ "$WARNING_READ" != "i have read the warning" ]
	then
		echo "Installation cancelled!"
		exit 0
	fi

	prog_line "Continuing with the installation after 3 seconds"
	sleep 3
fi

prog_line "Formatting $TARGET_PARTITION with ext4"
mkfs.ext4 -L BIRBOS $TARGET_PARTITION

prog_line "Mounting the BirbOS partition"
export LFS=/mnt/lfs

# Check if the partition is already mounted
LFS_MOUNTED_PARTITION="$(df | grep /mnt/lfs | awk '{print $1}')"
if [ "$LFS_MOUNTED_PARTITION" == "$TARGET_PARTITION" ]
then
	echo "$1 is already mounted to $LFS. Continuing..."
elif [ -z "$LFS_MOUNTED_PARTITION" ]
then
	mkdir -pv $LFS
	mount -v -t ext4 $TARGET_PARTITION $LFS
else
	echo "There's something already mounted to $LFS that is not $TARGET_PARTITION! Please unmount it and re-run this script!"
fi

prog_line "Preparing toolchain source files"
mkdir -pv $LFS/sources
chmod -v a+wt $LFS/sources

./bootstrap-scripts/download_sources.sh || { echo "There was an issue with downloading source files. Please re-try or look into the issue a bit more closely"; exit 1; }

prog_line "Creating the Linux directory layout"
mkdir -pv $LFS/{etc,var} $LFS/usr/{bin,lib,sbin}

for i in bin lib sbin; do
  ln -sv usr/$i $LFS/$i
done

# We'll assume that the system is 64-bit
mkdir -pv $LFS/lib64

# 32-bit stuff
mkdir -pv $LFS/usr/lib{,x}32
ln -sv usr/lib32 $LFS/lib32
ln -sv usr/libx32 $LFS/libx32

# Create the temporary tools directory for cross-compiling
mkdir -pv $LFS/tools

prog_line "Creating the LFS user"
groupadd lfs
useradd -s /bin/bash -g lfs -m -k /dev/null lfs

prog_line "Giving the LFS user permissions to the $LFS directories"
chown -v lfs $LFS/{usr{,/*},lib,var,etc,bin,sbin,tools}
chown -v lfs $LFS/lib64
chown -v lfs $LFS/{lib32,libx32}

prog_line "Copying all of the installation scripts into /home/lfs"
cp -vr ./bootstrap-scripts /home/lfs/
chown -v -R lfs:lfs /home/lfs/bootstrap-scripts

cp -v ./lfs-user-bootstrap.sh /home/lfs/
chown -v lfs:lfs /home/lfs/lfs-user-bootstrap.sh

run_as_lfs()
{
	sudo -H -u lfs bash -c "$1"
}

prog_line "Finishing the LFS user setup"
run_as_lfs './bootstrap-scripts/setup_lfs_user_env.sh'

# Make sure that the LFS user account works as expected
run_as_lfs './bootstrap-scripts/lfs_user_check.sh' || exit 1

prog_line "Logging in as the LFS user"
echo "To continue the installation, please run the script called 'lfs-user-bootstrap.sh' that should exist in this directory"

su - lfs
