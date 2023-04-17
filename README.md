# BirbOS
BirbOS is a GNU/Linux distribution mostly based on the [Linux From Scratch](https://www.linuxfromscratch.org/) project. The installation process is automated though, so no worries, you don't have to go through LFS manually to get this thing installed :P

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
