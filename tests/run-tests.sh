#!/bin/sh

ret=0
for T in */; do
	rm -rf "$T/out"
	(
		echo "Running test: $T"
		cd "$T"
		rm -rf out
		mkdir out
		sh run.sh
	)
	if diff -I ";serial" -Nru "$T/good" "$T/out"; then
		echo "$T GOOD"
	else
		echo "$T FAILED"
		ret=$(($ret+1))
	fi
done
exit $ret
