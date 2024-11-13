#!/bin/bash

if [ -z "$LFS" ]
then
	echo "The LFS environment variable is not set"
	exit 1
fi

LFS_SRC_PREFIX="$LFS/sources"
ERRORS=""

download()
{
	URL="$(echo "$1" | cut -d';' -f1)"
	MD5_SUM="$(echo "$1" | cut -d';' -f2)"

	FILE_NAME="$(basename "$URL")"

	# Check for existing files
	[ -f "$LFS_SRC_PREFIX/$FILE_NAME" ] && {
		if [ "$(md5sum "$LFS_SRC_PREFIX/$FILE_NAME" | cut -d' ' -f1)" == "$MD5_SUM" ]
		then
			echo "$FILE_NAME found"
		else
			rm -fv "$LFS_SRC_PREFIX/$FILE_NAME";
		fi
	}

	wget --directory-prefix="$LFS_SRC_PREFIX" "$URL"

	DOWNLOAD_MD5_SUM="$(md5sum "$LFS_SRC_PREFIX/$FILE_NAME" | cut -d' ' -f1)"
	[ "$DOWNLOAD_MD5_SUM" != "$MD5_SUM" ] && echo "MD5 mismatch with $FILE_NAME" && ERRORS="YES" && exit 1
}

# Source urls and md5sums
#shellcheck disable=SC1091
source ./bootstrap-scripts/packages.sh

# Get the list of variable names
PACKAGE_LIST="$(awk -F'=' '/^[A-Za-z0-9]/ {print $1}' ./bootstrap-scripts/packages.sh)"

# Download all of the packages
for i in $PACKAGE_LIST
do
	echo "Downloading: $i"
	download "${!i}"
done
echo "Finished downloading!"

# Make sure that all of the source files are owned by root
chown root:root "$LFS"/sources/*

[ -n "$ERRORS" ] && exit 1 || exit 0
