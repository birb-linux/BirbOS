#!/bin/sh

# This script handles the progression of the installation to
# make repeat runs of the install script a bit faster. This should
# help with development at least a little bit, since you can go backwards
# in the installation or continue where you last left off

PROGRESS_FILE="$HOME/BirbOS_Progress.txt"

# Make sure that the file exists
touch "$PROGRESS_FILE"

case $1 in
	add) echo "$2" >> "$PROGRESS_FILE" ;;
	check) grep -x "$2" "$PROGRESS_FILE" ;;
esac
