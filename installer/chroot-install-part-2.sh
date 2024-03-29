#!/bin/sh

# Continuation script for the chroot-install.sh script
# The script is split into two parts, because the bash shell
# is restarted at the end of the chroot-install.sh script and the script
# execution can't continue

prog_line()
{
	printf "> $1\n"
}

cd /

prog_line "Initializing log files"
touch /var/log/{btmp,lastlog,faillog,wtmp}
chgrp -v utmp /var/log/lastlog
chmod -v 664  /var/log/lastlog
chmod -v 600  /var/log/btmp

prog_line "Compiling the rest of the temporary tools"
export CHROOT_SECTION="temp_tools"

~/bootstrap-scripts/chroot-temptools/gettext.sh
~/bootstrap-scripts/chroot-temptools/bison.sh
~/bootstrap-scripts/chroot-temptools/perl.sh
~/bootstrap-scripts/chroot-temptools/python3.sh
~/bootstrap-scripts/chroot-temptools/texinfo.sh
~/bootstrap-scripts/chroot-temptools/util_linux.sh
~/bootstrap-scripts/chroot-temptools/stow.sh

# Make sure that stow got installed before continuing
# Birb won't work properly without it
file /usr/bin/stow || { echo "Stow seems to be missing... Please make sure that it was compiled correctly and then re-run this script"; exit 1; }

prog_line "Do some cleanup! This is to remove unnecessary files and save space"

# Remove currently installed documentation files
rm -rf /usr/share/{info,man,doc}/*

# Get rid of .la files, because they could cause issues with BLFS packages
find /usr/{lib,libexec} -name \*.la -delete
find /usr/lib32 -name \*.la -delete

# Remove the tools directory, because its not needed anymore
rm -rf /tools

# Recreate the documentation directories, so that stow doesn't take over them
mkdir -pv /usr/share/{info,man/man{1..8},doc}
touch /usr/share/info/.birb_symlink_lock
touch /usr/share/man/.birb_symlink_lock
touch /usr/share/man/man{1..8}/.birb_symlink_lock

# Make sure that stow can't take over certain other directories
touch /usr/share/pkgconfig/.birb_symlink_lock
mkdir -p /lib/udev/rules.d
touch /lib/udev/rules.d/.birb_symlink_lock


~/bootstrap-scripts/chroot-temptools/glibc.sh

prog_line "Compiling and installing birb ♪┏(・o･)┛♪"
BIRB_SRC_ROOT="/var/cache/distfiles/birb"
cd $BIRB_SRC_ROOT
make clean
make
make install

# FIXME: The kmod package gets rid of the /sbin symlink to /usr/sbin

# Make sure that the backup copies of coreutils are in the PATH
# variable after coreutils install overwrite
export PATH="$PATH:/usr/local/bin"

prog_line "Installing the rest of the system packages with birb"
yes 'n' | birb --install --overwrite man-pages iana-etc vim zlib bzip2 xz zstd file pkg-config ncurses readline m4 bc flex tcl expect dejagnu binutils gmp mpfr mpc isl attr acl libcap shadow gcc sed psmisc gettext bison grep bash libtool gdbm gperf expat inetutils less perl stow
yes 'n' | birb --install --overwrite xml-parser
yes 'n' | birb --install --overwrite intltool
yes 'n' | birb --install --overwrite autoconf automake openssl kmod libelf libffi python3 flit-core wheel ninja meson coreutils check diffutils gawk findutils groff popt mandoc icu libtasn1 p11-kit sqlite nspr nss make-ca curl libarchive libuv libxml2 nghttp2 cmake graphite2 wget gzip iproute2 kbd libpipeline make patch tar texinfo eudev man-db procps-ng util-linux e2fsprogs sysklogd sysvinit

# Python3 needs to be recompiled after sqlite is installed. Otherwise firefox won't compile
yes | birb --install python3

# Handle the freetype2 and harfbuzz chickend/egg issue
yes | birb --install --overwrite freetype
yes | birb --install --overwrite harfbuzz
yes | birb --install --overwrite freetype

## Reinstall graphite2 to add the freetype and harfbuzz functionality into it
yes | birb --install --overwrite graphite2


# Some applications (like steam for example) look for ldconfig from /sbin instead of /usr/sbin
[ ! -L /sbin/ldconfig ] && ln -srfv /usr/sbin/ldconfig /sbin/ldconfig

prog_line "Installing some custom udev rules meant for lfs installations"
cd /sources
tar -xf udev-lfs-20171102.tar.xz
make -f udev-lfs-20171102/Makefile.lfs install
rm -r udev-lfs-20171102

prog_line "Perform some cleanup"
rm -rf /tmp/*

# Remove harmful .la files
find /usr/lib /usr/libexec -name \*.la -delete
find /usr/lib32 -name \*.la -delete
find /usr/libx32 -name \*.la -delete

# Remove any partially installed temporary compiler stuff
find /usr -depth -name $(uname -m)-lfs-linux-gnu\* | xargs rm -rf

# Finish the base of the installation
cd /
./chroot-install-part-3.sh
