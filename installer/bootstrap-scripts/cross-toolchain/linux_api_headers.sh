#!/bin/bash
# shellcheck disable=SC1090,SC2154
# https://www.linuxfromscratch.org/~thomas/multilib/chapter05/linux-headers.html
set -e
~/bootstrap-scripts/installation_progress_manager.sh check "$0" && exit 0
source ~/bootstrap-scripts/packages.sh

PACKAGE="$linux"

. ~/bootstrap-scripts/prepare_sources.sh "$PACKAGE"

make mrproper

make headers
find usr/include -type f ! -name '*.h' -delete
cp -rv usr/include "$LFS/usr"

~/bootstrap-scripts/remove_sources.sh "$PACKAGE"
~/bootstrap-scripts/installation_progress_manager.sh add "$0"
