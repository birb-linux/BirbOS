#!/bin/sh

# Continuation script for the chroot-install.sh script
# The script is split into two parts, because the bash shell
# is restarted at the end of the chroot-install.sh script and the script
# execution can't continue

prog_line()
{
	printf "> $1\n"
}

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

~/bootstrap-scripts/chroot-temptools/glibc.sh

prog_line "Compiling and installing birb ♪┏(・o･)┛♪"
BIRB_SRC_ROOT="/var/cache/distfiles/birb"
cd $BIRB_SRC_ROOT
make clean
make
make install

prog_line "Installing the rest of the system packages with birb"
birb man-pages iana-etc vim zlib bzip2 xz zstd file pkg-config ncurses readline m4 bc flex tcl expect dejagnu binutils gmp mpfr mpc isl attr acl libcap shadow gcc sed psmisc gettext bison grep bash libtool gdbm gperf expat inetutils less perl stow xml-parser intltool autoconf automake openssl kmod libelf libffi python3 flit-core wheel ninja meson #coreutils
# TODO: Take a backup before enabling coreutils
