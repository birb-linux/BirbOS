#!/bin/bash

# This script is the continuation of the chroot-install-part-2.sh script.
# This part was separated from the second part, because the second script
# cannot be run repeatedly for testing purposes, because it contains compiling
# stuff without progress tracking.
#
# The purpose of this script is to finish the base of the BirbOS installation
# This includes some basicc configuration and setting up the kernel etc.

prog_line()
{
	printf "> $1\n"
}

# Source the configuration file
cd /
source /birb_config

prog_line "Install LFS-Bootscripts"
cd /sources
LFS_BOOTSCRIPTS="lfs-bootscripts-20230101"
tar -xvf $LFS_BOOTSCRIPTS.tar.xz
cd $LFS_BOOTSCRIPTS
make install
cd ..
rm -r $LFS_BOOTSCRIPTS

prog_line "Network configuration"

# Configure DNS settings
cat > /etc/resolv.conf << "EOF"
# Begin /etc/resolv.conf

nameserver DNS_SERVER

# End /etc/resolv.conf
EOF
sed -iv "s/DNS_SERVER/$DNS_SERVER/" /etc/resolv.conf

# Set the hostname
echo "$HOSTNAME" > /etc/hostname

# Create the /etc/hosts file
cat > /etc/hosts << "EOF"
# Begin /etc/hosts

127.0.0.1 localhost.localdomain localhost
::1       localhost ip6-localhost ip6-loopback
ff02::1   ip6-allnodes
ff02::2   ip6-allrouters

# End /etc/hosts
EOF


prog_line "Update certificates"
make-ca -g


prog_line "Configure SysVinit"
cat > /etc/inittab << "EOF"
# Begin /etc/inittab

id:3:initdefault:

si::sysinit:/etc/rc.d/init.d/rc S

l0:0:wait:/etc/rc.d/init.d/rc 0
l1:S1:wait:/etc/rc.d/init.d/rc 1
l2:2:wait:/etc/rc.d/init.d/rc 2
l3:3:wait:/etc/rc.d/init.d/rc 3
l4:4:wait:/etc/rc.d/init.d/rc 4
l5:5:wait:/etc/rc.d/init.d/rc 5
l6:6:wait:/etc/rc.d/init.d/rc 6

ca:12345:ctrlaltdel:/sbin/shutdown -t1 -a -r now

su:S06:once:/sbin/sulogin
s1:1:respawn:/sbin/sulogin

1:2345:respawn:/sbin/agetty --noclear tty1 9600
2:2345:respawn:/sbin/agetty tty2 9600
3:2345:respawn:/sbin/agetty tty3 9600
4:2345:respawn:/sbin/agetty tty4 9600
5:2345:respawn:/sbin/agetty tty5 9600
6:2345:respawn:/sbin/agetty tty6 9600

# End /etc/inittab
EOF


prog_line "Configure the system clock and timezone"
cat > /etc/sysconfig/clock << "EOF"
# Begin /etc/sysconfig/clock

UTC=1

# Set this to any options you might need to give to hwclock,
# such as machine hardware clock type for Alphas.
CLOCKPARAMS=

# End /etc/sysconfig/clock
EOF

echo "$TIME_ZONE" > /etc/timezone


prog_line "Set default console variables"
cat > /etc/sysconfig/console << "EOF"
# Begin /etc/sysconfig/console

LOGLEVEL="4"
KEYMAP="CONSOLE_KEYMAP"
FONT="lat0-16 -m 8859-15"

# End /etc/sysconfig/console
EOF
sed -i "s/CONSOLE_KEYMAP/$CONSOLE_KEYMAP/" /etc/sysconfig/console


prog_line "Configure Bash profile"
cat > /etc/profile << "EOF"
# Begin /etc/profile

export LANG=SYSTEM_LANGUAGE
export PATH=/usr/bin:/usr/sbin:/usr/local/bin:/bin:/sbin:/usr/python_bin
export PS1='\u@\h \w \$ '

# End /etc/profile
EOF
sed -i "s/SYSTEM_LANGUAGE/$SYSTEM_LANGUAGE/" /etc/profile


prog_line "Configure readline"
cat > /etc/inputrc << "EOF"
# Begin /etc/inputrc

# Allow the command prompt to wrap to the next line
set horizontal-scroll-mode Off

# Enable 8-bit input
set meta-flag On
set input-meta On

# Turns off 8th bit stripping
set convert-meta Off

# Keep the 8th bit for display
set output-meta On

# none, visible or audible
set bell-style none

# All of the following map the escape sequence of the value
# contained in the 1st argument to the readline specific functions
"\eOd": backward-word
"\eOc": forward-word

# for linux console
"\e[1~": beginning-of-line
"\e[4~": end-of-line
"\e[5~": beginning-of-history
"\e[6~": end-of-history
"\e[3~": delete-char
"\e[2~": quoted-insert

# for xterm
"\eOH": beginning-of-line
"\eOF": end-of-line

# for Konsole
"\e[H": beginning-of-line
"\e[F": end-of-line

# End /etc/inputrc
EOF


prog_line "Create the /etc/shells file"
cat > /etc/shells << "EOF"
# Begin /etc/shells

/bin/sh
/bin/bash

# End /etc/shells
EOF


prog_line "Configure fstab"
cat > /etc/fstab << "EOF"
# Begin /etc/fstab

# file system  mount-point  type     options             dump  fsck
#                                                              order

xxx     /            ext4    defaults            1     1
yyy         /boot                   vfat            noauto,noatime  1 2
#/dev/<yyy>     swap         swap     pri=1               0     0
proc           /proc        proc     nosuid,noexec,nodev 0     0
sysfs          /sys         sysfs    nosuid,noexec,nodev 0     0
devpts         /dev/pts     devpts   gid=5,mode=620      0     0
tmpfs          /run         tmpfs    defaults            0     0
devtmpfs       /dev         devtmpfs mode=0755,nosuid    0     0
tmpfs          /dev/shm     tmpfs    nosuid,nodev        0     0
tmpfs          /tmp         tmpfs    rw,nosuid,noatime,nodev,noexec,size=4G,mode=1777 0 0

# End /etc/fstab
EOF
sed -i "s|xxx|$TARGET_PARTITION|" /etc/fstab
sed -i "s|yyy|$BOOT_PARTITION|" /etc/fstab

prog_line "Mounting the /boot partition"
mount /boot

prog_line "Preparing for kernel configuration"
mkdir -pv /usr/src /etc/modprobe.d
cd /usr/src
[ -d /usr/src/linux-* ] && rm -r /usr/src/linux-*
tar -xf /sources/linux-*
ln -sf /usr/src/linux-* /usr/src/linux
cd /usr/src/linux
make mrproper
cp -f /root/misc_installation_files/kernel_config /usr/src/linux/.config

echo "The kernel sources are located at /usr/src/linux"
echo ""
echo "You can (and probably should) customize the kernel by entering the kernel"
echo "source directory and running the 'make menuconfig' command"
echo ""
echo "You can start the kernel configuration from scratch by deleting the default"
echo "/usr/src/linux/.config file"
echo ""
echo "When you are done with the kernel configuration, you can continue the installation"
echo "by running the chroot-install-part-4.sh script located at the root of the filesystem"
