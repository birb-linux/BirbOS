#!/bin/bash
# shellcheck disable=SC1090,SC2154
# https://www.linuxfromscratch.org/~thomas/multilib/chapter06/ncurses.html
set -e
~/bootstrap-scripts/installation_progress_manager.sh check "$0" && exit 0
source ~/bootstrap-scripts/packages.sh

PACKAGE="$ncurses"

. ~/bootstrap-scripts/prepare_sources.sh "$PACKAGE"

# Make sure that gawk is found
sed -i s/mawk// configure

# Build the tic program
mkdir build
pushd build
  ../configure
  make -C include
  make -C progs tic
popd

# Prapare for compilation
./configure --prefix=/usr                \
            --host="$LFS_TGT"            \
            --build="$(./config.guess)"  \
            --mandir=/usr/share/man      \
            --with-manpage-format=normal \
            --with-shared                \
            --without-normal             \
            --with-cxx-shared            \
            --without-debug              \
            --without-ada                \
            --disable-stripping          \
            AWK=gawk

make -j "$(nproc)"

make DESTDIR="$LFS" TIC_PATH="$(pwd)/build/progs/tic" install
ln -sv libncursesw.so "$LFS/usr/lib/libncurses.so"
sed -e 's/^#if.*XOPEN.*$/#if 1/' \
    -i "$LFS/usr/include/curses.h"

# Building the 32bit version
make distclean

CC="$LFS_TGT-gcc -m32"                  \
CXX="$LFS_TGT-g++ -m32"                 \
./configure --prefix=/usr               \
            --host="$LFS_TGT32"         \
            --build="$(./config.guess)" \
            --libdir=/usr/lib32         \
            --mandir=/usr/share/man     \
            --with-shared               \
            --without-normal            \
            --with-cxx-shared           \
            --without-debug             \
            --without-ada               \
            --disable-stripping

make -j "$(nproc)"

make DESTDIR="$PWD/DESTDIR" TIC_PATH="$(pwd)/build/progs/tic" install
ln -sv libncursesw.so DESTDIR/usr/lib32/libncurses.so
cp -Rv DESTDIR/usr/lib32/* "$LFS/usr/lib32"
rm -rf DESTDIR


~/bootstrap-scripts/remove_sources.sh "$PACKAGE"
~/bootstrap-scripts/installation_progress_manager.sh add "$0"
