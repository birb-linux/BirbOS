#!/bin/bash
# https://www.linuxfromscratch.org/~thomas/multilib/chapter07/util-linux.html
set -e
~/bootstrap-scripts/installation_progress_manager.sh check $0 && exit 0
source ~/bootstrap-scripts/packages.sh

PACKAGE="$util_linux"

. ~/bootstrap-scripts/prepare_sources.sh $PACKAGE

mkdir -pv /var/lib/hwclock

./configure --libdir=/usr/lib     \
            --runstatedir=/run    \
            --disable-chfn-chsh   \
            --disable-login       \
            --disable-nologin     \
            --disable-su          \
            --disable-setpriv     \
            --disable-runuser     \
            --disable-pylibmount  \
            --disable-static      \
            --disable-liblastlog2 \
            --without-python      \
            ADJTIME_PATH=/var/lib/hwclock/adjtime \
            --docdir=/usr/share/doc/util-linux-2.40

make -j$(nproc)

make install

# Install the 32-bit version
make distclean

CC="gcc -m32" \
./configure --host=i686-pc-linux-gnu \
		--libdir=/usr/lib32      \
		--runstatedir=/run       \
		--docdir=/usr/share/doc/util-linux-2.40 \
		--disable-chfn-chsh   \
		--disable-login       \
		--disable-nologin     \
		--disable-su          \
		--disable-setpriv     \
		--disable-runuser     \
		--disable-pylibmount  \
		--disable-static      \
		--disable-liblastlog2 \
		--without-python      \
		ADJTIME_PATH=/var/lib/hwclock/adjtime

make -j$(nproc)

make DESTDIR=$PWD/DESTDIR install
cp -Rv DESTDIR/usr/lib32/* /usr/lib32
rm -rf DESTDIR


~/bootstrap-scripts/remove_sources.sh $PACKAGE
~/bootstrap-scripts/installation_progress_manager.sh add $0
