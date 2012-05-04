# hosts2src.awk - generate a makehosts src file from /etc/hosts
# Copyright (C) 2004  Christoph Weber-Fahr
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.


# Script to generate a src file for makehosts from an 
# oldfashioned /etc/hosts
#
# Author:	Christoph Weber-Fahr
#
# 1.0	initial version				13.01.2004


BEGIN	  { print ";";
	    print "; proto src file generated automatically by hosts2src.awk";
	    "date" | getline datum;
	    print "; at " datum;
	    print "; ";
	    # ---- configure here -----------------------------------
	    domain = ".ivr.lab.net";
	    newdomain = ".ivr.lab.arcor.net";
	    # -------------------------------------------------------
	  }
	  
/^[;#].*/ { 		# handle comment lines
	    comment = ";" substr ($0, 2);
	    print comment ;
	    next;
	  }

/^[\t ]*$/ {next} # throw away empty lines

	  { ip = $1 ;

	    if (NF == 1) { printf ( "; -->%s<--\n", $0 ); next; };
	    if (match ($2, /^#/)) { printf ( "; -->%s<--\n", $0 ); next ;};
	    name = $2 ;
	    if (len = match ( $0, /#/ ))         # we have a trailing comment
	    {
		comment = "\t;" substr($0, len+1);
	    } else
	    {
		comment = "";
	    };
	
	    if (len =match (name, /\./ ) )  	# this is a FQDN
	    {  
		host = substr (name, 1, --len);
	    } else 
	    {
		host = name;
		len = length (host);
	    };
	    fqdn = host newdomain;
	    tabs = "";
	    # if (len < 16 ) { tabs = tabs "\t"; };
	    if (len <  8 ) { tabs = tabs "\t"; };
	    printf ("%s%s\tIN\tA\t%s%s\n", host, tabs, ip, comment);

	    for (i=3 ; i<=NF;i++)
	    {
	      name = $i;
	      if ( match (name, /^#/ ))   # trailing comment
	      { 
		next;
	      };
	      if (len = match (name, /\./ ) )  # this is a FQDN
              { 
		cname = substr (name, 1, --len);
	      } else
	      {
		cname = name;
		len = length (cname);
	      } 
	      tabs = "";
	      # if (len < 16 ) { tabs = tabs "\t"; };
	      if (len <  8 ) { tabs = tabs "\t"; };
	      if ( cname != host ) 
	      { 
	        printf ("%s%s\tIN\tCNAME\t%s.\n", cname, tabs, fqdn);
	      };
	    };
	  };

