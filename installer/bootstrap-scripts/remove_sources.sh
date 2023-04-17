#!/bin/sh

# This script is used to delete the extracted source files
# after compiling

# To use the script, simply pass in a package variable (see packages.sh)

set -e

cd $LFS/sources

TARBALL="$(echo $1 | cut -d';' -f1 | xargs basename)"
DIR_NAME="$(echo $TARBALL | sed 's/\.tar\.xz//; s/\.tar\.gz//')"

echo "Deleting $DIR_NAME..."
rm -rf $LFS/sources/$DIR_NAME
