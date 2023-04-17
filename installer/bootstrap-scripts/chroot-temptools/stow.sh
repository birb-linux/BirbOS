#!/bin/sh
set -e
~/bootstrap-scripts/installation_progress_manager.sh check $0 && exit 0
source ~/bootstrap-scripts/packages.sh

PACKAGE="$stow"

. ~/bootstrap-scripts/prepare_sources.sh $PACKAGE

./configure --prefix=/usr

make -j$(nproc)

make install

~/bootstrap-scripts/remove_sources.sh $PACKAGE
~/bootstrap-scripts/installation_progress_manager.sh add $0
