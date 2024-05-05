#!/bin/bash
# https://www.linuxfromscratch.org/~thomas/multilib/chapter06/file.html
set -e
~/bootstrap-scripts/installation_progress_manager.sh check $0 && exit 0
source ~/bootstrap-scripts/packages.sh

PACKAGE="$file"

. ~/bootstrap-scripts/prepare_sources.sh $PACKAGE

# Create a temporary copy of the host `file` command
mkdir build
pushd build
  ../configure --disable-bzlib      \
               --disable-libseccomp \
               --disable-xzlib      \
               --disable-zlib
  make
popd

./configure --prefix=/usr --host=$LFS_TGT --build=$(./config.guess)

make -j$(nproc) FILE_COMPILE=$(pwd)/build/src/file

make DESTDIR=$LFS install

# Remove the libtool archive file, because its harmful to the cross compilation
rm -v $LFS/usr/lib/libmagic.la

~/bootstrap-scripts/remove_sources.sh $PACKAGE
~/bootstrap-scripts/installation_progress_manager.sh add $0
