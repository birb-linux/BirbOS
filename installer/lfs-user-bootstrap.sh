#!/bin/sh

# This script will be run as the LFS user after the account has
# been created and initialized with the required configuration files

# Compile the cross compiling toolchain
./bootstrap-scripts/cross-toolchain/binutils_pass_1.sh
./bootstrap-scripts/cross-toolchain/gcc_pass_1.sh
./bootstrap-scripts/cross-toolchain/linux_api_headers.sh
./bootstrap-scripts/cross-toolchain/glibc.sh
./bootstrap-scripts/cross-toolchain/libstdc++.sh

# Corss compile temporary tools
./bootstrap-scripts/cross-toolchain/temporary_tools/m4.sh
./bootstrap-scripts/cross-toolchain/temporary_tools/ncurses.sh
./bootstrap-scripts/cross-toolchain/temporary_tools/bash.sh
./bootstrap-scripts/cross-toolchain/temporary_tools/coreutils.sh
./bootstrap-scripts/cross-toolchain/temporary_tools/diffutils.sh
./bootstrap-scripts/cross-toolchain/temporary_tools/file.sh
./bootstrap-scripts/cross-toolchain/temporary_tools/findutils.sh
./bootstrap-scripts/cross-toolchain/temporary_tools/gawk.sh
./bootstrap-scripts/cross-toolchain/temporary_tools/grep.sh
./bootstrap-scripts/cross-toolchain/temporary_tools/gzip.sh
./bootstrap-scripts/cross-toolchain/temporary_tools/make.sh
./bootstrap-scripts/cross-toolchain/temporary_tools/patch.sh
./bootstrap-scripts/cross-toolchain/temporary_tools/sed.sh
./bootstrap-scripts/cross-toolchain/temporary_tools/tar.sh
./bootstrap-scripts/cross-toolchain/temporary_tools/xz.sh
./bootstrap-scripts/cross-toolchain/temporary_tools/binutils_pass_2.sh
./bootstrap-scripts/cross-toolchain/temporary_tools/gcc_pass_2.sh

echo "To continue with the installation, there are some commands that need to be ran as the root user on the host, so please logout from the LFS user with the command 'exit'"
echo "After you have logged out, run the script 'bootstrap-chroot.sh' as the root user"
