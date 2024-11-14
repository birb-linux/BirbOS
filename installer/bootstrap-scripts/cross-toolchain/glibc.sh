#!/bin/bash
# shellcheck disable=SC1090,SC2154
# https://www.linuxfromscratch.org/~thomas/multilib/chapter05/glibc.html
set -e
~/bootstrap-scripts/installation_progress_manager.sh check "$0" && exit 0
source ~/bootstrap-scripts/packages.sh

PACKAGE="$glibc"

. ~/bootstrap-scripts/prepare_sources.sh "$PACKAGE"

# Create some symlinks for LSB compliance
ln -sfv ../lib/ld-linux-x86-64.so.2 "$LFS/lib64"
ln -sfv ../lib/ld-linux-x86-64.so.2 "$LFS/lib64/ld-lsb-x86-64.so.3"

# Apply FHS patch
patch -Np1 -i ../glibc-2.40-fhs-1.patch

mkdir -v build
cd       build

echo "rootsbindir=/usr/sbin" > configparms

../configure                                \
      --prefix=/usr                         \
      --host="$LFS_TGT"                     \
      --build="$(../scripts/config.guess)"  \
      --enable-kernel=4.19                  \
      --with-headers="$LFS/usr/include"     \
      --disable-nscd                        \
      libc_cv_slibdir=/usr/lib

make -j "$(nproc)"

make DESTDIR="$LFS" install

sed '/RTLDLIST=/s@/usr@@g' -i "$LFS/usr/bin/ldd"

# Do a sanity check
echo 'int main(){}' | "$LFS_TGT-gcc" -xc -
readelf -l a.out | grep ld-linux | grep '[Requesting program interpreter: /lib64/ld-linux-x86-64.so.2]'
rm -v a.out


# Build 32-bit support
make clean
find .. -name "*.a" -delete

CC="$LFS_TGT-gcc -m32"  \
CXX="$LFS_TGT-g++ -m32" \
../configure                               \
      --prefix=/usr                        \
      --host="$LFS_TGT32"                  \
      --build="$(../scripts/config.guess)" \
      --enable-kernel=4.19                 \
      --with-headers="$LFS/usr/include"    \
      --disable-nscd                       \
      --libdir=/usr/lib32                  \
      --libexecdir=/usr/lib32              \
      libc_cv_slibdir=/usr/lib32

make -j "$(nproc)"

make DESTDIR="$PWD/DESTDIR" install
cp -a DESTDIR/usr/lib32 "$LFS/usr/"
install -vm644 DESTDIR/usr/include/gnu/{lib-names,stubs}-32.h \
               "$LFS/usr/include/gnu/"
ln -svf ../lib32/ld-linux.so.2 "$LFS/lib/ld-linux.so.2"

# Perform another sanity check
echo 'int main(){}' > dummy.c
"$LFS_TGT-gcc" -m32 dummy.c
readelf -l a.out | grep '/ld-linux' | grep '[Requesting program interpreter: /lib/ld-linux.so.2]'
rm -v dummy.c a.out


~/bootstrap-scripts/remove_sources.sh "$PACKAGE"
~/bootstrap-scripts/installation_progress_manager.sh add "$0"
