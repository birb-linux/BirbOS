#!/bin/sh
# https://www.linuxfromscratch.org/~thomas/multilib/chapter05/gcc-libstdc++.html
set -e
~/bootstrap-scripts/installation_progress_manager.sh check $0 && exit 0
source ~/bootstrap-scripts/packages.sh

PACKAGE="$gcc"

. ~/bootstrap-scripts/prepare_sources.sh $PACKAGE

mkdir -v build
cd       build

../libstdc++-v3/configure           \
    --host=$LFS_TGT                 \
    --build=$(../config.guess)      \
    --prefix=/usr                   \
    --enable-multilib               \
    --disable-nls                   \
    --disable-libstdcxx-pch         \
    --with-gxx-include-dir=/tools/$LFS_TGT/include/c++/12.2.0

make -j$(nproc)

make DESTDIR=$LFS install

# Remove libtool archive files, because they are harmful for cross-compiling
rm -v $LFS/usr/lib/lib{stdc++,stdc++fs,supc++}.la

~/bootstrap-scripts/remove_sources.sh $PACKAGE
~/bootstrap-scripts/installation_progress_manager.sh add $0
