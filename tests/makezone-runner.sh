#!/bin/sh

ln -snf ../../beautify.awk .
cp "src" "src.tmp"
../../makezone "src.tmp" -short "$@"
rm -f "src.tmp"
ret=$?
rm -f beautify.awk
echo "$?"
