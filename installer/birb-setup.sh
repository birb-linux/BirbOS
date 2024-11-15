#!/bin/bash

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
mkdir -pv /usr/python_dist
mkdir -pv /usr/share/texmf
mkdir -pv $LFS/usr/lib/birb

touch $LIB_DIR/nest

if [ -d $REPO_DIR ]
then
	prog_line "Updating the existing package repository"
	cd "$REPO_DIR" || { echo "The repository directory $REPO_DIR does not exist"; exit 1; }
	git reset --hard
	git config pull.rebase true
	git fetch
	git pull
else
	prog_line "Cloning the BirbOS package repository"
	git clone https://github.com/Toasterbirb/BirbOS-packages $REPO_DIR
fi

if [ -d $BIRB_SRC_DIR ]
then
	prog_line "Updating the existing birb source files"
	cd "$BIRB_SRC_DIR" || { echo "The birb source code directory at $BIRB_SRC_DIR does not exist"; exit 1; }
	git reset --hard
	git config pull.rebase true
	git fetch
	git pull
else
	prog_line "Cloning the birb package manager"
	git clone https://github.com/Toasterbirb/birb $BIRB_SRC_DIR
fi

prog_line "Installing the birb configuration files"
cp -v $BIRB_SRC_DIR/*.conf $LFS/etc/

prog_line "Copying shared birb functions"
cp -v $BIRB_SRC_DIR/birb_funcs $LFS/usr/lib/birb/

prog_line "Downloading package tarballs"
$BIRB_SRC_DIR/birb --download man-pages iana-etc vim zlib bzip2 xz zstd file gmp mpfr ncurses readline m4 bc flex tcl expect dejagnu binutils mpc gcc isl attr acl libcap shadow pkg-config sed psmisc gettext bison grep bash libtool gdbm gperf expat inetutils less perl xstow xml-parser intltool autoconf automake openssl kmod libelf libffi python3 flit-core wheel ninja meson coreutils check diffutils gawk findutils groff popt mandoc efivar efibootmgr freetype harfbuzz icu libtasn1 p11-kit make-ca curl libarchive libuv libxml2 nghttp2 cmake graphite2 wget nss nspr sqlite gzip iproute2 kbd libpipeline make patch tar texinfo eudev man-db procps-ng util-linux e2fsprogs sysklogd sysvinit git

# The package manager installation will be finished
# in the chroot environment to avoid polluting the installation
# with the host distro
