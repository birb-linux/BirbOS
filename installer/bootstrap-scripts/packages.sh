# A list of packages and their versions in bash variable format
# This file will be sourced during the installation to gather version
# information etc.

# Format: package_name=source_tarball_url;md5sum

binutils="https://sourceware.org/pub/binutils/releases/binutils-2.40.tar.xz;007b59bd908a737c06e5a8d3d2c737eb"
gcc="https://ftp.gnu.org/gnu/gcc/gcc-12.2.0/gcc-12.2.0.tar.xz;73bafd0af874439dcdb9fc063b6fb069"
mpfr="https://ftp.gnu.org/gnu/mpfr/mpfr-4.2.0.tar.xz;a25091f337f25830c16d2054d74b5af7"
gmp="https://ftp.gnu.org/gnu/gmp/gmp-6.2.1.tar.xz;0b82665c4a92fd2ade7440c13fcaa42b"
mpc="https://ftp.gnu.org/gnu/mpc/mpc-1.3.1.tar.gz;5c9bc658c9fd0f940e8e3e0f09530c62"
linux="https://www.kernel.org/pub/linux/kernel/v6.x/linux-6.2.11.tar.xz;78d3ab3a52fe283aabca27dad4005d07"
glibc="https://ftp.gnu.org/gnu/glibc/glibc-2.37.tar.xz;e89cf3dcb64939d29f04b4ceead5cc4e"

# Some patches required for LFS
bzip2_documentation_patch="https://www.linuxfromscratch.org/patches/lfs/development/bzip2-1.0.8-install_docs-1.patch;6a5ac7e89b791aae556de0f745916f7f"
coreutils_internationalization_fixes_patch="https://www.linuxfromscratch.org/patches/lfs/development/coreutils-9.2-i18n-1.patch;3c6340b3ddd62f4acdf8d3caa6fad6b0"
glibc_fhs_patch="https://www.linuxfromscratch.org/patches/lfs/development/glibc-2.37-fhs-1.patch;9a5997c3452909b1769918c759eff8a2"
grub_upstream_fixes_patch="https://www.linuxfromscratch.org/patches/lfs/development/grub-2.06-upstream_fixes-1.patch;da388905710bb4cbfbc7bd7346ff9174"
kbd_backspace_delete_fix_patch="https://www.linuxfromscratch.org/patches/lfs/development/kbd-2.5.1-backspace-1.patch;f75cca16a38da6caa7d52151f7136895"
readline_upstream_fix_patch="https://www.linuxfromscratch.org/patches/lfs/development/readline-8.2-upstream_fix-1.patch;dd1764b84cfca6b677f44978218a75da"
sysvinit_consolidated_patch="https://www.linuxfromscratch.org/patches/lfs/development/sysvinit-3.06-consolidated-1.patch;17ffccbb8e18c39e8cedc32046f3a475"
