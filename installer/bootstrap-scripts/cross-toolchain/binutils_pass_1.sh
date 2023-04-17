#!/bin/sh
# https://www.linuxfromscratch.org/~thomas/multilib/chapter05/binutils-pass1.html
set -e
~/bootstrap-scripts/installation_progress_manager.sh check $0 && exit 0
source ~/bootstrap-scripts/packages.sh

PACKAGE="$binutils"

. ~/bootstrap-scripts/prepare_sources.sh $PACKAGE

mkdir -v build
cd       build

../configure --prefix=$LFS/tools       \
             --with-sysroot=$LFS \
             --target=$LFS_TGT   \
             --disable-nls       \
             --enable-gprofng=no \
             --disable-werror    \
             --enable-multilib

make -j$(nproc)

make install

~/bootstrap-scripts/remove_sources.sh $PACKAGE
~/bootstrap-scripts/installation_progress_manager.sh add $0
