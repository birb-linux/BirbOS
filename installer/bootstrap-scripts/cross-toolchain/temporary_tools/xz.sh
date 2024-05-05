#!/bin/sh
# https://www.linuxfromscratch.org/~thomas/multilib/chapter06/xz.html
set -e
~/bootstrap-scripts/installation_progress_manager.sh check $0 && exit 0
source ~/bootstrap-scripts/packages.sh

PACKAGE="$xz"

. ~/bootstrap-scripts/prepare_sources.sh $PACKAGE

./configure --prefix=/usr                     \
            --host=$LFS_TGT                   \
            --build=$(build-aux/config.guess) \
            --disable-static                  \
            --docdir=/usr/share/doc/xz-5.4.6

make -j$(nproc)

make DESTDIR=$LFS install

# Remove the libtool archive, because it is harmful for cross compilation
rm -v $LFS/usr/lib/liblzma.la

~/bootstrap-scripts/remove_sources.sh $PACKAGE
~/bootstrap-scripts/installation_progress_manager.sh add $0
