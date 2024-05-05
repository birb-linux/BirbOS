#!/bin/bash
# https://www.linuxfromscratch.org/~thomas/multilib/chapter06/bash.html
set -e
~/bootstrap-scripts/installation_progress_manager.sh check $0 && exit 0
source ~/bootstrap-scripts/packages.sh

PACKAGE="$bash"

. ~/bootstrap-scripts/prepare_sources.sh $PACKAGE

./configure --prefix=/usr                      \
            --build=$(sh support/config.guess) \
            --host=$LFS_TGT                    \
            --without-bash-malloc

make -j$(nproc)

make DESTDIR=$LFS install

# Set bash as the /bin/sh symlink
ln -sv bash $LFS/bin/sh

# There is some permission issue with removing the bash source files
# so we need to increment the progress before removing them, because
# that would trigger `set -e` and the progress wouldn't get incremented
~/bootstrap-scripts/installation_progress_manager.sh add $0
~/bootstrap-scripts/remove_sources.sh $PACKAGE
