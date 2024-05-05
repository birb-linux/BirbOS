# shellcheck disable=SC2034
# A list of packages and their versions in bash variable format
# This file will be sourced during the installation to gather version
# information etc.

# Format: package_name=source_tarball_url;md5sum

binutils="https://sourceware.org/pub/binutils/releases/binutils-2.42.tar.xz;a075178a9646551379bfb64040487715"
gcc="https://ftp.gnu.org/gnu/gcc/gcc-13.2.0/gcc-13.2.0.tar.xz;e0e48554cc6e4f261d55ddee9ab69075"
mpfr="https://ftp.gnu.org/gnu/mpfr/mpfr-4.2.1.tar.xz;523c50c6318dde6f9dc523bc0244690a"
gmp="https://ftp.gnu.org/gnu/gmp/gmp-6.3.0.tar.xz;956dc04e864001a9c22429f761f2c283"
mpc="https://ftp.gnu.org/gnu/mpc/mpc-1.3.1.tar.gz;5c9bc658c9fd0f940e8e3e0f09530c62"
linux="https://www.kernel.org/pub/linux/kernel/v6.x/linux-6.8.8.tar.xz;d802ace782a45e14cc4a8efee7510dfd"
glibc="https://ftp.gnu.org/gnu/glibc/glibc-2.39.tar.xz;be81e87f72b5ea2c0ffe2bedfeb680c6"

m4="https://ftp.gnu.org/gnu/m4/m4-1.4.19.tar.xz;0d90823e1426f1da2fd872df0311298d"
ncurses="https://invisible-mirror.net/archives/ncurses/ncurses-6.5.tar.gz;ac2d2629296f04c8537ca706b6977687"
bash="https://ftp.gnu.org/gnu/bash/bash-5.2.21.tar.gz;ad5b38410e3bf0e9bcc20e2765f5e3f9"
coreutils="https://ftp.gnu.org/gnu/coreutils/coreutils-9.5.tar.xz;e99adfa059a63db3503cc71f3d151e31"
diffutils="https://ftp.gnu.org/gnu/diffutils/diffutils-3.10.tar.xz;2745c50f6f4e395e7b7d52f902d075bf"
file="https://astron.com/pub/file/file-5.45.tar.gz;26b2a96d4e3a8938827a1e572afd527a"
findutils="https://ftp.gnu.org/gnu/findutils/findutils-4.9.0.tar.xz;4a4a547e888a944b2f3af31d789a1137"
gawk="https://ftp.gnu.org/gnu/gawk/gawk-5.3.0.tar.xz;97c5a7d83f91a7e1b2035ebbe6ac7abd"
grep="https://ftp.gnu.org/gnu/grep/grep-3.11.tar.xz;7c9bbd74492131245f7cdb291fa142c0"
gzip="https://ftp.gnu.org/gnu/gzip/gzip-1.13.tar.xz;d5c9fc9441288817a4a0be2da0249e29"
make="https://ftp.gnu.org/gnu/make/make-4.4.1.tar.gz;c8469a3713cbbe04d955d4ae4be23eeb"
patch="https://ftp.gnu.org/gnu/patch/patch-2.7.6.tar.xz;78ad9937e4caadcba1526ef1853730d5"
sed="https://ftp.gnu.org/gnu/sed/sed-4.9.tar.xz;6aac9b2dbafcd5b7a67a8a9bcb8036c3"
tar="https://ftp.gnu.org/gnu/tar/tar-1.35.tar.xz;a2d8042658cfd8ea939e6d911eaf4152"
xz="https://anduin.linuxfromscratch.org/LFS/xz-5.4.6.tar.xz;7ade7bd1181a731328f875bec62a9377"
gettext="https://ftp.gnu.org/gnu/gettext/gettext-0.22.5.tar.xz;3ae5580599d84be93e6213930facb2db"
bison="https://ftp.gnu.org/gnu/bison/bison-3.8.2.tar.xz;c28f119f405a2304ff0a7ccdcc629713"
perl="https://www.cpan.org/src/5.0/perl-5.38.2.tar.xz;d3957d75042918a23ec0abac4a2b7e0a"
python3="https://www.python.org/ftp/python/3.12.3/Python-3.12.3.tar.xz;8defb33f0c37aa4bdd3a38ba52abde4e"
texinfo="https://ftp.gnu.org/gnu/texinfo/texinfo-7.1.tar.xz;edd9928b4a3f82674bcc3551616eef3b"
util_linux="https://www.kernel.org/pub/linux/utils/util-linux/v2.40/util-linux-2.40.tar.xz;46d1423122d310dfd022c799e1e4e259"
udev_lfs="https://anduin.linuxfromscratch.org/LFS/udev-lfs-20230818.tar.xz;acd4360d8a5c3ef320b9db88d275dae6"

# Some patches required for LFS
bzip2_documentation_patch="https://www.linuxfromscratch.org/patches/lfs/development/bzip2-1.0.8-install_docs-1.patch;6a5ac7e89b791aae556de0f745916f7f"
coreutils_internationalization_fixes_patch="https://www.linuxfromscratch.org/patches/lfs/development/coreutils-9.5-i18n-1.patch;ce7529b74564aac887c3f48582a5e6cf"
glibc_fhs_patch="https://www.linuxfromscratch.org/patches/lfs/development/glibc-2.39-fhs-1.patch;9a5997c3452909b1769918c759eff8a2"
# grub_upstream_fixes_patch="https://www.linuxfromscratch.org/patches/lfs/11.3/grub-2.06-upstream_fixes-1.patch;da388905710bb4cbfbc7bd7346ff9174"
readline_upstream_fix_patch="https://www.linuxfromscratch.org/patches/lfs/development/readline-8.2-upstream_fixes-3.patch;9ed497b6cb8adcb8dbda9dee9ebce791"

# Some extra packages needed to finish the installation
xstow="https://ftp.gnu.org/gnu/stow/stow-2.3.1.tar.gz;4dfd82b93bb6702d018b1d57e498a74d"
tzdata="https://www.iana.org/time-zones/repository/releases/tzdata2024a.tar.gz;2349edd8335245525cc082f2755d5bf4"
lfs_bootscripts="https://www.linuxfromscratch.org/lfs/downloads/development/lfs-bootscripts-20240416.tar.xz;67cf86692c1ed5abdffcb244a1890a90"
