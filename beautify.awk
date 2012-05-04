# beautify.awk - make makehosts output more readable.
# Copyright (C) 1996-2003  Christoph Weber-Fahr
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


# Script to bring makehosts output files into a more readable fashion.
# normally only necessary for regular zone files - the reverse ones
# already come out nicely from makehosts
# 
# Author: Christoph Weber-Fahr
#
# 1.0 	initial version				sometime in June 1996 
# 1.1	added NS record support			12-11-1996
# 1.2	added SRV record support, minor
#	bug fixes 				18-12-2003
# 1.3   minor fixes for IPv6 zone file support  11-01-2011


	{  if (match ($0,/^[\#;].*/)) {  # handle comments
		print;
		next
		};
	   feld = 1;
	   name = "\t";
	   if (match($0, /^[0-9a-zA-Z_-]/)) {
	        name = $1;
		feld = 2 ;
		name_l = (length(name)) ;
	  	if (name_l < 8) name = name "\t" ;
		};
	   ttl = "\t";
	   if (match ($(feld), /^[0-9]+$/)) {
		ttl = "\t" $(feld);
		feld++;
		} 
 	   else {
		if (name_l > 15) {
		    ttl = "";
		    };
		};
	   class = "\t";
	   if (match ($(feld), /^IN$/)) {
		class = "\t" $(feld);
		feld++ ;
		};
	   if (match($(feld), /^(A|AAAA|CNAME|MX|PTR|NS|SRV)$/)){
		# print formatted
		printf("%s%s%s\t%s\t", name, ttl, class, $(feld));
		for (j=feld+1;j<=NF;j++) {
		   printf ("  %s", $(j))
		   }
		print "";
	    	}
	   else print;
	
	}

