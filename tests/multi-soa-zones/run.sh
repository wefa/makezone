#!/bin/sh

../makezone-multirunner.sh \
	src.1.tmp \
	-f lab1.example.org	out/db.org.example.lab1 \
	src.2.tmp \
	-f lab2.example.org	out/db.org.example.lab2 \
	-r 192.0.2 		out/db.192.0.2 \
	
