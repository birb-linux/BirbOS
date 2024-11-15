# shellcheck disable=SC2034
# A list of packages and their versions in bash variable format
# This file will be sourced during the installation to gather version
# information etc.

# Format: package_name=source_tarball_url;md5sum

binutils="https://sourceware.org/pub/binutils/releases/binutils-2.43.1.tar.xz;9202d02925c30969d1917e4bad5a2320"
gcc="https://ftp.gnu.org/gnu/gcc/gcc-14.2.0/gcc-14.2.0.tar.xz;2268420ba02dc01821960e274711bde0"
mpfr="https://ftp.gnu.org/gnu/mpfr/mpfr-4.2.1.tar.xz;523c50c6318dde6f9dc523bc0244690a"
gmp="https://ftp.gnu.org/gnu/gmp/gmp-6.3.0.tar.xz;956dc04e864001a9c22429f761f2c283"
mpc="https://ftp.gnu.org/gnu/mpc/mpc-1.3.1.tar.gz;5c9bc658c9fd0f940e8e3e0f09530c62"
linux="https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.11.7.tar.xz;29a9594b9fd614c55c89fe58b6dde6cf"
glibc="https://ftp.gnu.org/gnu/glibc/glibc-2.40.tar.xz;b390feef233022114950317f10c4fa97"

m4="https://ftp.gnu.org/gnu/m4/m4-1.4.19.tar.xz;0d90823e1426f1da2fd872df0311298d"
ncurses="https://invisible-mirror.net/archives/ncurses/ncurses-6.5.tar.gz;ac2d2629296f04c8537ca706b6977687"
bash="https://ftp.gnu.org/gnu/bash/bash-5.2.37.tar.gz;9c28f21ff65de72ca329c1779684a972"
coreutils="https://ftp.gnu.org/gnu/coreutils/coreutils-9.5.tar.xz;e99adfa059a63db3503cc71f3d151e31"
diffutils="https://ftp.gnu.org/gnu/diffutils/diffutils-3.10.tar.xz;2745c50f6f4e395e7b7d52f902d075bf"
file="https://astron.com/pub/file/file-5.45.tar.gz;26b2a96d4e3a8938827a1e572afd527a"
findutils="https://ftp.gnu.org/gnu/findutils/findutils-4.10.0.tar.xz;870cfd71c07d37ebe56f9f4aaf4ad872"
gawk="https://ftp.gnu.org/gnu/gawk/gawk-5.3.1.tar.xz;4e9292a06b43694500e0620851762eec"
grep="https://ftp.gnu.org/gnu/grep/grep-3.11.tar.xz;7c9bbd74492131245f7cdb291fa142c0"
gzip="https://ftp.gnu.org/gnu/gzip/gzip-1.13.tar.xz;d5c9fc9441288817a4a0be2da0249e29"
make="https://ftp.gnu.org/gnu/make/make-4.4.1.tar.gz;c8469a3713cbbe04d955d4ae4be23eeb"
patch="https://ftp.gnu.org/gnu/patch/patch-2.7.6.tar.xz;78ad9937e4caadcba1526ef1853730d5"
sed="https://ftp.gnu.org/gnu/sed/sed-4.9.tar.xz;6aac9b2dbafcd5b7a67a8a9bcb8036c3"
tar="https://ftp.gnu.org/gnu/tar/tar-1.35.tar.xz;a2d8042658cfd8ea939e6d911eaf4152"
xz="https://github.com//tukaani-project/xz/releases/download/v5.6.3/xz-5.6.3.tar.xz;57581b216a82482503bb63c8170d549c"
gettext="https://ftp.gnu.org/gnu/gettext/gettext-0.22.5.tar.xz;3ae5580599d84be93e6213930facb2db"
bison="https://ftp.gnu.org/gnu/bison/bison-3.8.2.tar.xz;c28f119f405a2304ff0a7ccdcc629713"
perl="https://www.cpan.org/src/5.0/perl-5.40.0.tar.xz;cfe14ef0709b9687f9c514042e8e1e82"
python3="https://www.python.org/ftp/python/3.13.0/Python-3.13.0.tar.xz;726e5b829fcf352326874c1ae599abaa"
texinfo="https://ftp.gnu.org/gnu/texinfo/texinfo-7.1.1.tar.xz;e5fc595794a7980f98ce446a5f8aa273"
util_linux="https://www.kernel.org/pub/linux/utils/util-linux/v2.40/util-linux-2.40.2.tar.xz;88faefc8fefced097e58142077a3d14e"
udev_lfs="https://anduin.linuxfromscratch.org/LFS/udev-lfs-20230818.tar.xz;acd4360d8a5c3ef320b9db88d275dae6"

# Some patches required for LFS
bzip2_documentation_patch="https://www.linuxfromscratch.org/patches/lfs/development/bzip2-1.0.8-install_docs-1.patch;6a5ac7e89b791aae556de0f745916f7f"
coreutils_internationalization_fixes_patch="https://www.linuxfromscratch.org/patches/lfs/development/coreutils-9.5-i18n-2.patch;58961caf5bbdb02462591fa506c73b6d"
glibc_fhs_patch="https://www.linuxfromscratch.org/patches/lfs/development/glibc-2.40-fhs-1.patch;9a5997c3452909b1769918c759eff8a2"
#grub_upstream_fixes_patch="https://www.linuxfromscratch.org/patches/lfs/11.3/grub-2.06-upstream_fixes-1.patch;da388905710bb4cbfbc7bd7346ff9174"
#readline_upstream_fix_patch="https://www.linuxfromscratch.org/patches/lfs/11.3/readline-8.2-upstream_fix-1.patch;dd1764b84cfca6b677f44978218a75da"

# Some extra packages needed to finish the installation
xstow="https://github.com/majorkingleo/xstow/releases/download/1.1.1/xstow-1.1.1.tar.gz;2fedf18c5f8bac34a160cc4c2ac0e423"
tzdata="https://www.iana.org/time-zones/repository/releases/tzdata2024b.tar.gz;e1d010b46844502f12dcff298c1b7154"
lfs_bootscripts="https://www.linuxfromscratch.org/lfs/downloads/development/lfs-bootscripts-20240825.tar.xz;c3b8f9c710c8b54ed4a45938bb3b5301"
