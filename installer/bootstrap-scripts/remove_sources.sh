#!/bin/bash

# This script is used to delete the extracted source files
# after compiling

# To use the script, simply pass in a package variable (see packages.sh)

set -e

TARBALL="$(echo "$1" | cut -d';' -f1 | xargs basename)"
DIR_NAME="$(echo "$TARBALL" | sed 's/\.tar\.xz//; s/\.tar\.gz//')"

# We need to run different commands when in the chroot environment
if [ "$CHROOT_SECTION" == "temp_tools" ]
then
	cd /sources

	echo "Deleting $DIR_NAME..."
	rm -rf "/sources/$DIR_NAME"
else
	cd "$LFS/sources"

	echo "Deleting $DIR_NAME..."
	rm -rf "$LFS/sources/$DIR_NAME"
fi
