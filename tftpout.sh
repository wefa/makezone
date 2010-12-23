#!/bin/sh

if [ -f /usr/xpg4/bin/grep ] ; then 
   GREP=/usr/xpg4/bin/grep
else
   GREP=`which grep`
fi

if [ "$1" = "" ] ; then
   cat >> /dev/stderr << EOF

   $0: command line tftp file tranfer
 
   Usage:

   $0 <local> <host> [ <remote> ]

	<local>:	local source file name
	<host>:		name or ip of remote tftp server
	<remote>:	remote destination file name

EOF
exit
fi

tftp $2 > tftpout << EOF 
	binary
	put $1 $3
EOF

returned=`$GREP -E '(Error|No target|timed out)' tftpout`

if [ ! -z "$returned" ] ; then
   echo $returned
   exit 1
fi
