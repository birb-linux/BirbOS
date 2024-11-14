#!/bin/bash
# shellcheck disable=SC1090,SC2154
# https://www.linuxfromscratch.org/~thomas/multilib/chapter07/bison.html
set -e
~/bootstrap-scripts/installation_progress_manager.sh check "$0" && exit 0
source ~/bootstrap-scripts/packages.sh

PACKAGE="$bison"

. ~/bootstrap-scripts/prepare_sources.sh "$PACKAGE"

./configure --prefix=/usr \
            --docdir=/usr/share/doc/bison-3.8.2

make -j "$(nproc)"

make install

~/bootstrap-scripts/remove_sources.sh "$PACKAGE"
~/bootstrap-scripts/installation_progress_manager.sh add "$0"
