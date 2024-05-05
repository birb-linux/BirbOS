#!/bin/bash
# https://www.linuxfromscratch.org/~thomas/multilib/chapter05/gcc-pass1.html
set -e
~/bootstrap-scripts/installation_progress_manager.sh check $0 && exit 0
source ~/bootstrap-scripts/packages.sh

PACKAGE="$gcc"

. ~/bootstrap-scripts/prepare_sources.sh $PACKAGE

# Extract some packages required to compile gcc
tar -xf ../mpfr-4.2.1.tar.xz
mv -v mpfr-4.2.1 mpfr
tar -xf ../gmp-6.3.0.tar.xz
mv -v gmp-6.3.0 gmp
tar -xf ../mpc-1.3.1.tar.gz
mv -v mpc-1.3.1 mpc

# Set default directory names for libraries
sed -e '/m64=/s/lib64/lib/' \
    -e '/m32=/s/m32=.*/m32=..\/lib32$(call if_multiarch,:i386-linux-gnu)/' \
    -i.orig gcc/config/i386/t-linux64

mkdir -v build
cd       build

mlist=m64,m32
../configure                  \
    --target=$LFS_TGT                              \
    --prefix=$LFS/tools                            \
    --with-glibc-version=2.39                      \
    --with-sysroot=$LFS                            \
    --with-newlib                                  \
    --without-headers                              \
    --enable-default-pie                           \
    --enable-default-ssp                           \
    --enable-initfini-array                        \
    --disable-nls                                  \
    --disable-shared                               \
    --enable-multilib --with-multilib-list=$mlist  \
    --disable-decimal-float                        \
    --disable-threads                              \
    --disable-libatomic                            \
    --disable-libgomp                              \
    --disable-libquadmath                          \
    --disable-libssp                               \
    --disable-libvtv                               \
    --disable-libstdcxx                            \
    --enable-languages=c,c++

make -j$(nproc)

make install

cd ..
cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
  `dirname $($LFS_TGT-gcc -print-libgcc-file-name)`/install-tools/include/limits.h

~/bootstrap-scripts/remove_sources.sh $PACKAGE
~/bootstrap-scripts/installation_progress_manager.sh add $0
