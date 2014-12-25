#!/bin/sh

for item in $( env ); do
case $item in
ACTION=online)
	/bin/cb-display-tool -o 4 -m 4
	killall -9 Xorg
	;;
ACTION=offline)
	/bin/cb-display-tool -o 8 -m 4
	killall -9 Xorg
	;;
*)
	;;
esac

done
