#!/bin/sh

# Setup and prepare the birb package manager for use.

# This script can also be used to re-create any missing files/directories
# to repair a possibly broken installation. Though if your system is catastropihally
# borked, consider doing a full reinstallation at that point to save yourself
# some headache

# NOTE! This script only works when run on a host distro as the root user!
# This script shouldn't be run in the BirbOS chroot or in a running installation!
# Consider yourself warned

export LFS=/mnt/lfs
source ./installer-funcs.sh

CACHE_DIR="$LFS/var/cache"
LIB_DIR="$LFS/var/lib/birb"
DB_DIR="$LFS/var/db"

REPO_DIR="$DB_DIR/pkg"
BIRB_SRC_DIR="$CACHE_DIR/distfiles/birb"

prog_line "Setting up directories and files for the birb package manager"
mkdir -pv $DB_DIR/fakeroot
mkdir -pv $CACHE_DIR/distfiles
mkdir -pv $LIB_DIR

touch $LIB_DIR/nest

if [ -d $REPO_DIR ]
then
	prog_line "Removing the existing package repository"
	rm -r $REPO_DIR
fi

prog_line "Cloning the BirbOS package repository"
git clone https://github.com/Toasterbirb/BirbOS-packages $REPO_DIR

if [ -d $BIRB_SRC_DIR ]
then
	prog_line "Removing the existing birb source files"
	rm -r $BIRB_SRC_DIR
fi

prog_line "Cloning the birb package manager"
git clone https://github.com/Toasterbirb/birb $BIRB_SRC_DIR


prog_line "Downloading package tarballs"
$BIRB_SRC_DIR/birb --download man-pages iana-etc

# The package manager installation will be finished
# in the chroot environment to avoid polluting the installation
# with the host distro
