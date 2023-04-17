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

