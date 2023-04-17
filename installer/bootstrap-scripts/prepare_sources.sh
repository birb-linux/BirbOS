#!/bin/sh

# This script will extract the source tarball and enter
# the source directory. Any required patches need to be applied
# in the package installation script manually

# To use the script, simply pass in a package variable (see packages.sh)

set -e

TARBALL="$(echo $1 | cut -d';' -f1 | xargs basename)"
DIR_NAME="$(echo $TARBALL | sed 's/\.tar\.xz//; s/\.tar\.gz//')"

# We need to run different commands when in the chroot environment
if [ "$CHROOT_SECTION" == "temp_tools" ]
then
	cd /sources

	# If the sources have already been extracted, delete
	# the extracted directory
	[ -d "/sources/$DIR_NAME" ] && rm -rfv "/sources/$DIR_NAME"

	echo "Extracting $TARBALL..."
	tar -xf $TARBALL
	cd "/sources/$DIR_NAME"
else
	cd $LFS/sources

	# If the sources have already been extracted, delete
	# the extracted directory
	[ -d "$LFS/sources/$DIR_NAME" ] && rm -rfv "$LFS/sources/$DIR_NAME"

	echo "Extracting $TARBALL..."
	tar -xf $TARBALL
	cd "$LFS/sources/$DIR_NAME"
fi
