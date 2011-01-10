#!/bin/sh

../makezone-runner.sh \
	-f lab.example.org				out/db.org.example.lab \
	-r 2001:db8:0001::/48 				out/db.2001.0db8.0001.48 \
	-r 2001:db8:0002:1234::/64 			out/db.2001.0db8.0002.1234.64 \
	-r 2001:db8:0002:5600::/55 			out/db.2001.0db8.0002.5600.55 \
	-r 2001:db8:0002:7890:abcd:ef01:2345:6788/126 	out/db.2001.0db8.0002.7890.abcd.ef01.2345.6788.126 \
	
