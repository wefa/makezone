#!/bin/sh

ln -snf ../../beautify.awk .
cp "src" "src.tmp"
! ../../makezone "src.tmp" -short "$@" >out/errorlog 2>&1
ret=$?
rm -f "src.tmp"
rm -f beautify.awk
exit "$ret"
