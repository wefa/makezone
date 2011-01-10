#!/bin/sh

../makezone-runner.sh \
	-f subdomain.lab.example.org	out/db.org.example.lab.subdomain \
	-r 192.168.17.32/27		out/db.192.168.17.32.27 \
	-r 192.168.16.0/24		out/db.192.168.16 \
	-r 192.168.20.0/22		out/db.192.168.20.0.22 \
	
