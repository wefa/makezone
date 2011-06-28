#!/bin/sh

ln -snf ../../beautify.awk .
for X in src.*; do
	cp "$X" "$X.tmp"
done
../../makezone -short "$@" && awk -f ../../makehosts.awk src.*.tmp | perl ../../sorthosts.pl > out/hosts
ret=$?
rm -f src.*.tmp
rm -f beautify.awk
exit "$ret"
