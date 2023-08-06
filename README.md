# BirbOS
BirbOS is a GNU/Linux distribution mostly based on the [Linux From Scratch](https://www.linuxfromscratch.org/) project. The installation process is automated though, so no worries, you don't have to go through LFS manually to get this thing installed :P

There are no stage-3 tarballs available and everything is compiled from the ground up, so make sure you have enough time in your hands if you decide to install BirbOS on your computers. It is impossible to give any time estimates, but simply saying that the installation involves compiling gcc thrice should give some direction.

> **Warning**
> If you plan on installing BirbOS, please read the [Disclaimer](#disclaimer) chapter carefully. Installing BirbOS will make changes to your host distro and there's a risk for data loss if you are not careful

## Table of contents
- [Disclaimer](#disclaimer)
- [Related projects](#related-projects)
- [Features](#features)
- [Installation](#installation)
    - [Configuration](#configuration)
    - [Starting the installation](#starting-the-installation)
    - [Kernel configuration](#kernel-configuration)
    - [Booting](#booting)
- [Post installation](#post-installation)
    - [Chrooting into BirbOS](#chrooting-into-birbos)
    - [Connecting to the internet](#connecting-to-the-internet)
    - [How to install packages](#how-to-install-packages)
		- [Distro independent package management schemes](#distro-independent-package-management-schemes)
			- [AppImage](#appimage)
			- [Flatpak](#flatpak)
			- [Nix store](#nix-store)
			- [Snap](#snap)
			- [Stealing packages from other distros](#stealing-packages-from-other-distros)

## Disclaimer
**This is a learning project at most and shouldn't be relied upon as a production ready distro!** If you want similar, but a smoother and way better Linux desktop experience, please use [Gentoo](https://www.gentoo.org/) instead.

During the installation, there will be modifications to the host distribution, so be careful. Here are some of the changes that will be made:
- A new user account "lfs" will be created and used to build the BirbOS installation
- A partition defined in the installation config file will be formatted with ext4 and mounted to /mnt/lfs (the /mnt/lfs directory will be created during the installation)
- Possibly changes to the /boot partition to make the installation bootable

There might be some other changes too that I'm forgetting, but these should be the major ones. If you are unsure about the safety of your files, please use a virtual machine and/or take good backups.

## Related projects
- [birb](https://github.com/Toasterbirb/birb) - Package manager
- [birb-utils](https://github.com/Toasterbirb/birb-utils) - Miscellaneous utility scripts and programs made for BirbOS

## Features
These are the main "goals" of this project:
- [x] A custom package manager called [birb](https://github.com/Toasterbirb/birb)
- [x] 32-bit support. I want muh Steam games to work
- [x] Support for Nvidia gpus and possibly hybrid graphics for laptops.
- [x] Full X11 desktop with dwm
- [ ] Full Wayland desktop with dwl
	- [ ] Wayland alternatives for basic stuff like image viewers, terminal emulators...
- [ ] Enough packages in repos to get school work done
- [ ] Wine, Lutris and Steam for windows gaming
- [ ] (Bonus) A way to re-install the system in a somewhat reproducible way

As for games ATM, the Steam launcher is in the core repository, but Steam refuses to connect to the internet. You might have some luck running native linux games however by copying the files over

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
- M.2 NVMe SSD
- Realtek Semiconductor Co., Ltd. RTL8125
- Family 17h/19h HD Audio Controller
- No WiFi / Bluetooth

If your hardware configuration is something similar to what is listed above, you might have some luck with minimal editing using the provided kernel configuration. The kernel config has most of the Intel CPU stuff and AMD GPU options disabled.

### Booting
The scripts only copy the kernel files to /boot and do nothing else. The bootloader needs to be set up manually by the user. This might involve creating a custom menuentry to GRUB etc. Make sure to set the root partition in the menuentry appropriately.

`efibootmgr` is packaged in the core repository, so you can use that as a GRUB alternative.

## Post installation
The base installation of BirbOS is quite barebones. It has things like `git`, `wget` and `curl` installed however, so you can easily download more stuff from the internet (assuming you get that working). You can finish the system installation by booting into your fresh BirbOS installation or by staying in the [chroot environment](#chrooting-into-birbos).

> **Note**
> This is a good point to take a full backup of the BirbOS root filesystem in case something goes wrong with the rest of the installation, unless you want to spend more time compiling stuff all over again

### Chrooting into BirbOS
Whenever something goes horribly wrong and you can't boot to BirbOS for some reason, you can attempt to chroot into it. You can do this by mounting the BirbOS root partition to the `/mnt/lfs` directory that was created during the installation. After that, simply run the script `./installer/enter_chroot.sh` located in the BirbOS source directory. The script will chroot into the BirbOS installation after bind mounting /dev, /proc, /sys etc.. In the chroot environment you can run commands as the root user.

If the problem is so severe that you can't chroot to your installation (due to missing files etc.), you might want to restore your backups to the mounted filesystem (you took backups, right?). Just remember that the `/usr/bin` directory in BirbOS doesn't actually contain the binaries but rather symlinks to `/var/db/fakeroot`, so if you want to copy over something into that directory to fix thing, you might have to reinstall those said packages with `birb` later on with the `birb --install --overwrite` flags if you want to keep using the system normally.

### Connecting to the internet
> **Important**
> If you need dhcpcd or any other networking related programs, remember to install them in the chroot environment before rebooting to BirbOS. Downloading packages without internet is difficult

By default there won't be any network interfaces up. You can fix this with the `ifconfig` command. To get an IP address, start the `dhcpcd` daemon.

If there are any errors referring to firmware, refer to [this LFS page](https://www.linuxfromscratch.org/blfs/view/stable/postlfs/firmware.html) for instructions on how to install any missing firmware blobs.

### How to install packages
Installing packages with `birb` is as simple as this
```sh
birb vim htop pfetch
```
You can install multiple packages consecutively at once and the package manager will figure out the dependencies needed to make that happen.

You can uninstall something with the `--uninstall` flag
```sh
birb --uninstall emacs
```

Have a look at the `birb` man page for more detailed instructions
```sh
man birb
```

If you don't want to use the included package manager, you can also install software by manually compiling from source.

#### Distro independent package management schemes
##### AppImage
AppImages aren't supported out-of-the-box due to missing libraries, but you can attempt extracting the AppImage files and running them manually. This might require some env variable tweaking to get working.

You might be able to get AppImages working natively if you manage to compile and install fuse2.

##### Flatpak
Flatpak isn't supported yet due to some missing dependencies, but it might be packaged in the future to make installing big 32bit programs like Steam easier and more convinient.

If feasible, flatpak could be integrated into `birb` directly as an optional thing to increase package availability and possibly security when running proprietary software.

##### Nix store
The nix store should be fairly trivial to install with no conflicts with the instructions found [here](https://nixos.org/manual/nix/unstable/installation/installation.html).

##### Snap
No.

##### Stealing packages from other distros
Extracting deb and rpm files can work in some cases, but in no way is supported or endorsed. You might get away with installing a few such packages with `stow` or some other reversable way, but expect dependency trouble. The mentioned two package management schemes are used by distros with possibly way different (runtime) dependency versions and some packages might also expect SystemD to be present.
