#!/bin/sh

ln -snf ../../beautify.awk .
cp "src" "src.tmp"
../../makezone "src.tmp" -short "$@"
ret=$?
rm -f "src.tmp"
rm -f beautify.awk
exit "$ret"
