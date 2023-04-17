#!/bin/sh

# This script will extract the source tarball and enter
# the source directory. Any required patches need to be applied
# in the package installation script manually

# To use the script, simply pass in a package variable (see packages.sh)

set -e

cd $LFS/sources

TARBALL="$(echo $1 | cut -d';' -f1 | xargs basename)"
DIR_NAME="$(echo $TARBALL | sed 's/\.tar\.xz//; s/\.tar\.gz//')"

# If the sources have already been extracted, delete
# the extracted directory
[ -d "$LFS/sources/$DIR_NAME" ] && rm -rfv "$LFS/sources/$DIR_NAME"

echo "Extracting $TARBALL..."
tar -xf $TARBALL
cd "$LFS/sources/$DIR_NAME"
