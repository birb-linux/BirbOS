#!/bin/sh
# https://www.linuxfromscratch.org/~thomas/multilib/chapter06/grep.html
set -e
~/bootstrap-scripts/installation_progress_manager.sh check $0 && exit 0
source ~/bootstrap-scripts/packages.sh

PACKAGE="$grep"

. ~/bootstrap-scripts/prepare_sources.sh $PACKAGE

./configure --prefix=/usr   \
            --host=$LFS_TGT

make -j$(nproc)

make DESTDIR=$LFS install

~/bootstrap-scripts/remove_sources.sh $PACKAGE
~/bootstrap-scripts/installation_progress_manager.sh add $0
