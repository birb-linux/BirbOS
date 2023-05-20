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

#echo "$TIME_ZONE" > /etc/timezone
ln -sv /usr/share/zoneinfo/$TIME_ZONE /etc/localtime


prog_line "Set default console variables"
cat > /etc/sysconfig/console << "EOF"
# Begin /etc/sysconfig/console

LOGLEVEL="4"
KEYMAP="CONSOLE_KEYMAP"
FONT="lat0-16 -m 8859-15"

# End /etc/sysconfig/console
EOF
sed -i "s/CONSOLE_KEYMAP/$CONSOLE_KEYMAP/" /etc/sysconfig/console


prog_line "Configure bash profile"
cat > /etc/profile << "EOF"
# Begin /etc/profile

# Set system language
export LANG=SYSTEM_LANGUAGE

# Add any directories here that you want to add into the global PATH variable
export PATH=/usr/bin:/usr/sbin:/usr/local/bin:/bin:/sbin:/usr/python_bin

# Set up some shell history environment variables
export HISTSIZE=1000
export HISTIGNORE="&:[bf]g:exit"

# Set some defaults for graphical systems
export XDG_DATA_DIRS=${XDG_DATA_DIRS:-/usr/share/}
export XDG_CONFIG_DIRS=${XDG_CONFIG_DIRS:-/etc/xdg/}
export XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR:-/tmp/xdg-$USER}

# Set up a red prompt for root and a green one for users
if [[ $EUID == 0 ]] ; then
  PS1="\[\033[01;31m\]\h\[\033[01;34m\] \w \$\[\033[00m\] "
else
  PS1="\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] "
fi

# Run any startup scripts located at /etc/profile.d
for script in /etc/profile.d/*.sh ; do
        if [ -r $script ] ; then
                . $script
        fi
done

unset script

# End /etc/profile
EOF
sed -i "s/SYSTEM_LANGUAGE/$SYSTEM_LANGUAGE/" /etc/profile
install --directory --mode=0755 --owner=root --group=root /etc/profile.d

#prog_line "Setup bash completion"
#cat > /etc/profile.d/bash_completion.sh << "EOF"
## Begin /etc/profile.d/bash_completion.sh
## Import bash completion scripts
#
## If the bash-completion package is installed, use its configuration instead
#if [ -f /usr/share/bash-completion/bash_completion ]; then
#
#  # Check for interactive bash and that we haven't already been sourced.
#  if [ -n "${BASH_VERSION-}" -a -n "${PS1-}" -a -z "${BASH_COMPLETION_VERSINFO-}" ]; then
#
#    # Check for recent enough version of bash.
#    if [ ${BASH_VERSINFO[0]} -gt 4 ] || \
#       [ ${BASH_VERSINFO[0]} -eq 4 -a ${BASH_VERSINFO[1]} -ge 1 ]; then
#       [ -r "${XDG_CONFIG_HOME:-$HOME/.config}/bash_completion" ] && \
#            . "${XDG_CONFIG_HOME:-$HOME/.config}/bash_completion"
#       if shopt -q progcomp && [ -r /usr/share/bash-completion/bash_completion ]; then
#          # Source completion code.
#          . /usr/share/bash-completion/bash_completion
#       fi
#    fi
#  fi
#
#else
#
#  # bash-completions are not installed, use only bash completion directory
#  if shopt -q progcomp; then
#    for script in /etc/bash_completion.d/* ; do
#      if [ -r $script ] ; then
#        . $script
#      fi
#    done
#  fi
#fi
#
## End /etc/profile.d/bash_completion.sh
#EOF
#
#install --directory --mode=0755 --owner=root --group=root /etc/bash_completion.d


prog_line "Set the 'umask' variable"
cat > /etc/profile.d/umask.sh << "EOF"
# By default, the umask should be set.
if [ "$(id -gn)" = "$(id -un)" -a $EUID -gt 99 ] ; then
  umask 002
else
  umask 022
fi
EOF


prog_line "Create the default bashrc file"
cat > /etc/bashrc << "EOF"
if [[ $- != *i* ]] ; then
	# Shell is non-interactive
	return
fi

shopt -s checkwinsize
shopt -s no_empty_cmd_completion
shopt -s histappend

# Some colorful commands
alias ls='ls --color=auto'
alias grep='grep --color=auto'

# Set vim as the default editor
export EDITOR=vim

# Set a much more expressive default sudo prompt
export SUDO_PROMPT="(* ^ ω ^) Mayw I hav ur passwrd sir: "
EOF



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

cat > /etc/profile.d/readline.sh << "EOF"
# Set up the INPUTRC environment variable.
if [ -z "$INPUTRC" -a ! -f "$HOME/.inputrc" ] ; then
        INPUTRC=/etc/inputrc
fi
export INPUTRC
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

prog_line "Install git for birb"
yes 'n' | git

prog_line "Install a bootscript that makes the random entropy Pools less predictable during startup"
cd /tmp
BOOTSCRIPT_FILE_PATH="blfs-bootscripts-20230101"
wget https://anduin.linuxfromscratch.org/BLFS/blfs-bootscripts/${BOOTSCRIPT_FILE_PATH}.tar.xz
tar -xf $BOOTSCRIPT_FILE_PATH.tar.xz
cd /tmp/$BOOTSCRIPT_FILE_PATH
make install-random
cd /tmp
rm -rf $BOOTSCRIPT_FILE_PATH $BOOTSCRIPT_FILE_PATH.tar.xz

prog_line "Preparing for kernel configuration"
mkdir -pv /usr/src /etc/modprobe.d
cd /usr/src
#[ -d /usr/src/linux-* ] && rm -r /usr/src/linux-*
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
