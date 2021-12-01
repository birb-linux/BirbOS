#!/bin/bash

version=5.8.3
#version=5.15.5


# Move to the kernel source directory
#cd /sources/linux-5.8.3
cd /sources/linux-${version}
#make mrproper
#cp /boot/config .config
#cp /boot/config /boot/config_backup
#make menuconfig

# Compile the kernel
make -j8
make modules_install
echo "Kernel compiling done!"

# Move files to /boot
cp -v arch/x86/boot/bzImage /boot/vmlinuz-${version}-lfs-10.0
cp -v System.map /boot/System.map-${version}

date=$(date "+%d-%m-%Y_%H-%M")
cp -v .config /boot/config
cp -v .config /root/kernel/configs/config_${date}_${version}
echo "New kernel installed!"

echo "Reinstalling nvidia driver modules"
#/root/nvidia/NVIDIA-Linux-x86_64-460.39/nvidia-installer -Ks
