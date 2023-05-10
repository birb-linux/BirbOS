# BirbOS
BirbOS is a GNU/Linux distribution mostly based on the [Linux From Scratch](https://www.linuxfromscratch.org/) project. The installation process is automated though, so no worries, you don't have to go through LFS manually to get this thing installed :P

## Table of contents
- [Disclaimer](#disclaimer)
- [Features](#features)
- [Installation](#installation)
    - [Configuration](#configuration)
    - [Starting the installation](#starting-the-installation)
    - [Kernel configuration](#kernel-configuration)
    - [Booting](#booting)

## Disclaimer
**This is a learning project at most and shouldn't be relied upon as a production ready distro!** If you want similar, but a smoother and way better Linux desktop experience, please use [Gentoo](https://www.gentoo.org/) instead.

During the installation, there will be modifications to the host distribution, so be careful. Here are some of the changes that will be made:
- A new user account "lfs" will be created and used to build the BirbOS installation
- A partition defined in the installation config file will be formatted with ext4 and mounted to /mnt/lfs (the /mnt/lfs directory will be created during the installation)
- Possibly changes to the /boot partition to make the installation bootable

There might be some other changes too that I'm forgetting, but these should be the major ones. If you are unsure about the safety of your files, please use a virtual machine and/or take good backups.

## Features
These are the main "goals" of this project:
- A custom package manager called [birb](https://github.com/Toasterbirb/birb)
- 32-bit support. I want muh Steam games to work
- Support for Nvidia gpus and possibly hybrid graphics for laptops.
- Full X11 desktop with dwm
- Enough packages in repos to get school work done
- Wine, Lutris and Steam for windows gaming
- (Bonus) A way to re-install the system in a somewhat reproducible way

## Installation
The installation is mostly guided with instructions shown in the installation script output. There shouldn't be any user intervention required during the installation other than what the scripts tell you to do.

**Before you do anything permanent, make sure to take full backups of anything you think is important.**

### Configuration
The installation requires a configuration file. There is a sample config provided at `./installer/bootstrap_conf_example`. All of the variables are required and none should be left empty.

### Starting the installation
To start the installation, go into the `./installer` directory and run the following command
```sh
sudo ./bootstrap.sh /path/to/the/config_file
```
The rest of the instructions will be given during the installation. Whenever some installation script finishes, it will tell what to do and what script to run next.

Here are some of the scripts that are run during the installation:
- `bootstrap.sh` Starts the installation and sets up the LFS user
- `lfs-user-bootstrap.sh` Compiles the cross compiling toochain and temporary tools as the LFS user
- `bootstrap-chroot.sh` Sets up the BirbOS chroot environment and chroots into it
- `chroot-install.sh` Creates the rest of the core filesystem and does some basic configuration
- `chroot-install-part-2.sh` Continuation for the `chroot-install.sh` script after the shell restart. It compiles the rest of the temporary tools, installs the [birb](https://github.com/Toasterbirb/birb) package manager and then uses it to install the rest of the needed packages overwriting the temporary tools
- `chroot-install-part-3.sh` Continuation for the `chroot-install-part-2.sh` script and gets run automatically. It creates the rest of the required system configuration files and prepared the kernel for compiling
- `chroot-install-part-4.sh` The end of the installation. The script compiles and installs the kernel, creates a few last configuration files and cleans up most of the temporary files from the BirbOS installation

### Kernel configuration
The default kernel config file that is bundled with the installation scripts is quite barebone and probably doesn't work on any other devices other than the main developer of this distribution. You'll have to figure out the required kernel options yourself with programs like `lspci` etc. on the host distro. There might also be some missing firmware that you'll need to acquire. Refer to [this LFS page](https://www.linuxfromscratch.org/blfs/view/stable/postlfs/firmware.html) for instructions on how to install any missing firmware blobs.

The default kernel is configured with this hardware list in mind
- AMD Ryzen 5 5600G
- NVIDIA GeForce RTX 3060
- NVMe SSD
- Realtek Semiconductor Co., Ltd. RTL8125
- Family 17h/19h HD Audio Controller

If your hardware configuration is something similar to what is listed above, you might have some luck with minimal editing using the provided kernel configuration. The kernel config has most of the Intel CPU stuff and AMD GPU options disabled.

### Booting
The scripts only copy the kernel files to /boot and do nothing else. The bootloader needs to be set up manually by the user. This might involve creating a custom menuentry to GRUB etc. Make sure to set the root partition in the menuentry appropriately
