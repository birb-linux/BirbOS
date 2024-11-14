#!/bin/bash
# shellcheck disable=SC1090,SC2154
# https://www.linuxfromscratch.org/~thomas/multilib/chapter06/binutils-pass2.html
set -e
~/bootstrap-scripts/installation_progress_manager.sh check "$0" && exit 0
source ~/bootstrap-scripts/packages.sh

PACKAGE="$binutils"

. ~/bootstrap-scripts/prepare_sources.sh "$PACKAGE"

# Make sure that the produced binaries won't be mistakenly linked from the host distro
# shellcheck disable=SC2016
sed '6009s/$add_dir//' -i ltmain.sh

mkdir -v build
cd       build

../configure                        \
    --prefix=/usr                   \
    --build="$(../config.guess)"    \
    --host="$LFS_TGT"               \
    --disable-nls                   \
    --enable-shared                 \
    --enable-gprofng=no             \
    --disable-werror                \
    --enable-64-bit-bfd             \
    --enable-default-hash-style=gnu \
    --enable-multilib

make -j "$(nproc)"

make DESTDIR="$LFS" install

# Remove the libtool archive files, because they are harmful for cross compilation
rm -v "$LFS"/usr/lib/lib{bfd,ctf,ctf-nobfd,opcodes,sframe}.{a,la}

~/bootstrap-scripts/remove_sources.sh "$PACKAGE"
~/bootstrap-scripts/installation_progress_manager.sh add "$0"
