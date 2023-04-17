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

prog_line "Do some cleanup! This is to remove unnecessary files and save space"

# Remove currently installed documentation files
rm -rf /usr/share/{info,man,doc}/*

# Get rid of .la files, because they could cause issues with BLFS packages
find /usr/{lib,libexec} -name \*.la -delete
find /usr/lib{,x}32 -name \*.la -delete

# Remove the tools directory, because its not needed anymore
rm -rf /tools

prog_line "Compiling and installing birb ♪┏(・o･)┛♪"
BIRB_SRC_ROOT="/var/cache/distfiles/birb"
cd $BIRB_SRC_ROOT
make clean
make
make install