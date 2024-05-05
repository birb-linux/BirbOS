#!/bin/bash
# https://www.linuxfromscratch.org/~thomas/multilib/chapter06/gawk.html
set -e
~/bootstrap-scripts/installation_progress_manager.sh check $0 && exit 0
source ~/bootstrap-scripts/packages.sh

PACKAGE="$gawk"

. ~/bootstrap-scripts/prepare_sources.sh $PACKAGE

sed -i 's/extras//' Makefile.in

./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)

make -j$(nproc)

make DESTDIR=$LFS install

~/bootstrap-scripts/remove_sources.sh $PACKAGE
~/bootstrap-scripts/installation_progress_manager.sh add $0
