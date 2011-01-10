#!/bin/sh

ret=0
for TT in */; do
	T=${TT%/}
	echo -n "$T... "
	rm -rf "$T/out"
	(
		cd "$T"
		rm -rf out
		mkdir out
		sh run.sh >log 2>&1
	)
	status=$?
	if [ $status != 0 ]; then
		echo "BAD"
		cat "$T/log"
		ret=$(($ret+1))
	else
		if diff -I ";serial" -Nru "$T/good" "$T/out" 2>&1 >>"$T/log"; then
			echo "GOOD"
		else
			echo "BAD"
			cat "$T/log"
			ret=$(($ret+1))
		fi
	fi
done
exit $ret
