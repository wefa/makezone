#!/bin/sh

ln -snf ../../beautify.awk .
cp "src" "src.tmp"
../../makezone "src.tmp" "$@"
rm -f "src.tmp"
ret=$?
rm -f beautify.awk
echo "$?"