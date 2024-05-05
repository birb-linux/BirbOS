#!/bin/bash
set -e
~/bootstrap-scripts/installation_progress_manager.sh check $0 && exit 0
source ~/bootstrap-scripts/packages.sh

PACKAGE="$xstow"

. ~/bootstrap-scripts/prepare_sources.sh $PACKAGE

./configure --prefix=/usr --enable-static

make -j$(nproc)

make install

~/bootstrap-scripts/remove_sources.sh $PACKAGE
~/bootstrap-scripts/installation_progress_manager.sh add $0
