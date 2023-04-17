#!/bin/sh
# https://www.linuxfromscratch.org/~thomas/multilib/chapter07/gettext.html
set -e
~/bootstrap-scripts/installation_progress_manager.sh check $0 && exit 0
source ~/bootstrap-scripts/packages.sh

PACKAGE="$gettext"

. ~/bootstrap-scripts/prepare_sources.sh $PACKAGE

./configure --disable-shared

make -j$(nproc)

# Only install three required tools
cp -v gettext-tools/src/{msgfmt,msgmerge,xgettext} /usr/bin

~/bootstrap-scripts/remove_sources.sh $PACKAGE
~/bootstrap-scripts/installation_progress_manager.sh add $0
