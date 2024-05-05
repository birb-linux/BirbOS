#!/bin/bash
# https://www.linuxfromscratch.org/~thomas/multilib/chapter07/Python.html

# This package is known to fail at one part because of missing dependencies
# and that's okay, so we'll keep on compiling even if there's an error
#set -e

~/bootstrap-scripts/installation_progress_manager.sh check $0 && exit 0
source ~/bootstrap-scripts/packages.sh

PACKAGE="$python3"

. ~/bootstrap-scripts/prepare_sources.sh $PACKAGE

./configure --prefix=/usr   \
            --enable-shared \
            --without-ensurepip

make -j$(nproc)

make install

~/bootstrap-scripts/remove_sources.sh $PACKAGE
~/bootstrap-scripts/installation_progress_manager.sh add $0
