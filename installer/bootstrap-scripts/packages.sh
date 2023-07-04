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

m4="https://ftp.gnu.org/gnu/m4/m4-1.4.19.tar.xz;0d90823e1426f1da2fd872df0311298d"
ncurses="https://invisible-mirror.net/archives/ncurses/ncurses-6.4.tar.gz;5a62487b5d4ac6b132fe2bf9f8fad29b"
bash="https://ftp.gnu.org/gnu/bash/bash-5.2.15.tar.gz;4281bb43497f3905a308430a8d6a30a5"
coreutils="https://ftp.gnu.org/gnu/coreutils/coreutils-9.3.tar.xz;040b4b7acaf89499834bfc79609af29f"
diffutils="https://ftp.gnu.org/gnu/diffutils/diffutils-3.9.tar.xz;cf0a65266058bf22fe3feb69e57ffc5b"
file="https://astron.com/pub/file/file-5.44.tar.gz;a60d586d49d015d842b9294864a89c7a"
findutils="https://ftp.gnu.org/gnu/findutils/findutils-4.9.0.tar.xz;4a4a547e888a944b2f3af31d789a1137"
gawk="https://ftp.gnu.org/gnu/gawk/gawk-5.2.1.tar.xz;02956bc5d117a7437bb4f7039f23b964"
grep="https://ftp.gnu.org/gnu/grep/grep-3.10.tar.xz;ab3f063ad4596b7d094fb5f66cf327d6"
gzip="https://ftp.gnu.org/gnu/gzip/gzip-1.12.tar.xz;9608e4ac5f061b2a6479dc44e917a5db"
make="https://ftp.gnu.org/gnu/make/make-4.4.1.tar.gz;c8469a3713cbbe04d955d4ae4be23eeb"
patch="https://ftp.gnu.org/gnu/patch/patch-2.7.6.tar.xz;78ad9937e4caadcba1526ef1853730d5"
sed="https://ftp.gnu.org/gnu/sed/sed-4.9.tar.xz;6aac9b2dbafcd5b7a67a8a9bcb8036c3"
tar="https://ftp.gnu.org/gnu/tar/tar-1.34.tar.xz;9a08d29a9ac4727130b5708347c0f5cf"
xz="https://tukaani.org/xz/xz-5.4.2.tar.xz;1dcdf002d9a69f48ff67be84964af0d8"
gettext="https://ftp.gnu.org/gnu/gettext/gettext-0.21.1.tar.xz;27fcc8a42dbc8f334f23a08f1f2fe00a"
bison="https://ftp.gnu.org/gnu/bison/bison-3.8.2.tar.xz;c28f119f405a2304ff0a7ccdcc629713"
perl="https://www.cpan.org/src/5.0/perl-5.36.0.tar.xz;826e42da130011699172fd655e49cfa2"
python3="https://www.python.org/ftp/python/3.11.3/Python-3.11.3.tar.xz;c8d52fc4fb8ad9932a11d86d142ee73a"
texinfo="https://ftp.gnu.org/gnu/texinfo/texinfo-7.0.3.tar.xz;37bf94fd255729a14d4ea3dda119f81a"
util_linux="https://www.kernel.org/pub/linux/utils/util-linux/v2.38/util-linux-2.38.1.tar.xz;cd11456f4ddd31f7fbfdd9488c0c0d02"
udev_lfs="https://anduin.linuxfromscratch.org/LFS/udev-lfs-20171102.tar.xz;27cd82f9a61422e186b9d6759ddf1634"

# Some patches required for LFS
bzip2_documentation_patch="https://www.linuxfromscratch.org/patches/lfs/development/bzip2-1.0.8-install_docs-1.patch;6a5ac7e89b791aae556de0f745916f7f"
coreutils_internationalization_fixes_patch="https://www.linuxfromscratch.org/patches/lfs/development/coreutils-9.3-i18n-1.patch;3c6340b3ddd62f4acdf8d3caa6fad6b0"
glibc_fhs_patch="https://www.linuxfromscratch.org/patches/lfs/development/glibc-2.37-fhs-1.patch;9a5997c3452909b1769918c759eff8a2"
grub_upstream_fixes_patch="https://www.linuxfromscratch.org/patches/lfs/development/grub-2.06-upstream_fixes-1.patch;da388905710bb4cbfbc7bd7346ff9174"
readline_upstream_fix_patch="https://www.linuxfromscratch.org/patches/lfs/development/readline-8.2-upstream_fix-1.patch;dd1764b84cfca6b677f44978218a75da"

# Some extra packages needed to finish the installation
stow="https://ftp.gnu.org/gnu/stow/stow-2.3.1.tar.gz;4dfd82b93bb6702d018b1d57e498a74d"
tzdata="https://www.iana.org/time-zones/repository/releases/tzdata2023c.tar.gz;5aa672bf129b44dd915f8232de38e49a"
lfs_bootscripts="https://www.linuxfromscratch.org/lfs/downloads/development/lfs-bootscripts-20230101.tar.xz;0bd3cfcdf8e48ac670377392429291ee"
