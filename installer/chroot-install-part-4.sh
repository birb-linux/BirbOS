#!/bin/bash

# This script is the continuation of the chroot-install-part-3.sh script
# and should be run after kernel configuration has been done.
#
# This script will setup the rest of the base system installation
# and hopefully make the system bootable

prog_line()
{
	printf "> %s\n" "$1"
}

prog_line "Loading installation variables"
source /birb_config

prog_line "Compiling the kernel"
cd /usr/src/linux || exit 1
make -j "$(nproc)"

#prog_line "Installing kernel modules"
#make modules_install

prog_line "Mounting the boot partition"
mount $BOOT_PARTITION /boot

prog_line "Installing the BirbOS kernel files to /boot"
KERNEL_VERSION="$(file /usr/src/linux | awk '{print $5}' | xargs basename | cut -d'-' -f2)"
cp -iv /usr/src/linux/arch/x86/boot/bzImage "/boot/vmlinuz-${KERNEL_VERSION}-birbos"
cp -iv /usr/src/linux/System.map "/boot/System.map-${KERNEL_VERSION}"

prog_line "Finalizing the base installation"
cat > /etc/lsb-release << "EOF"
DISTRIB_ID="BirbOS"
DISTRIB_RELEASE="1.0"
EOF

prog_line "Sourcing /etc/profile"
source /etc/profile

cat > /etc/os-release << "EOF"
NAME="BirbOS"
VERSION="1.0"
ID=birbos
PRETTY_NAME="BirbOS"
EOF

prog_line "Cleaning up installation files"
#rm -rf /sources
rm -f /chroot-install-part-*.sh
rm -f /birb_config
rm -f /chroot-install.sh
rm -rf /root/{BirbOS_Progress.txt,bootstrap-scripts}

prog_line "Remove some possibly broken symlinks"
[ -L /usr/lib/lib ] && rm -v /usr/lib/lib
[ -L /usr/lib32/lib32 ] && rm -v /usr/lib32/lib32
[ -L /usr/bin/bin ] && rm -v /usr/bin/bin
[ -L /sbin/sbin ] && rm -v /sbin/sbin

echo "Lets setup a password for the root user!"
passwd

echo ""
echo "Installation finished!"
echo "To actually boot into the system, you need to set that up on"
echo "the host system that you used to install BirbOS"
echo ""
echo "This might involve fiddling with GRUB etc."
