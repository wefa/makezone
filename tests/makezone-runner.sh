#!/bin/sh

ln -snf ../../beautify.awk .
cp "src" "src.tmp"
../../makezone "src.tmp" -short "$@" && awk -f ../../makehosts.awk src.tmp | perl ../../sorthosts.pl > out/hosts
ret=$?
rm -f "src.tmp"
rm -f beautify.awk
exit "$ret"
