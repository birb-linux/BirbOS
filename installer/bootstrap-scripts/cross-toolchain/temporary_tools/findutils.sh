#!/bin/bash
# shellcheck disable=SC1090,SC2154
# https://www.linuxfromscratch.org/~thomas/multilib/chapter06/findutils.html
set -e
~/bootstrap-scripts/installation_progress_manager.sh check "$0" && exit 0
source ~/bootstrap-scripts/packages.sh

PACKAGE="$findutils"

. ~/bootstrap-scripts/prepare_sources.sh "$PACKAGE"

./configure --prefix=/usr                   \
            --localstatedir=/var/lib/locate \
            --host="$LFS_TGT"               \
            --build="$(build-aux/config.guess)"

make -j "$(nproc)"

make DESTDIR="$LFS" install

~/bootstrap-scripts/remove_sources.sh "$PACKAGE"
~/bootstrap-scripts/installation_progress_manager.sh add "$0"
