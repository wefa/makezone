# makehosts.awk - generate a hosts file from BIND zone files
# Copyright (C) 1996-2005  Christoph Weber-Fahr
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


# Script to generate an oldfashioned hosts file from
# named zone file
#
# Author:	Christoph Weber-Fahr
#
# 1.0	initial version				some time in june 1996
# 1.1	fixes for multiple zones		971008
# 1.2	modification for ignore_pc_X		980422
# 1.3	fixed filename bug			050621


BEGIN	  { print "#";
	    print "# /etc/hosts generated automatically by makehosts.awk";
	    "date" | getline datum;
	    "pwd"  | getline pwd;
	    domainstring = "do.main.missing";
            ignore_pc_X = 1;
	  }
	  
	  { ipno = "" }

/^; Domainsource/ { domainstring = $3 }

/^[;#].*/ {next}

/^>[0-9A-Z]* / {sub (/^>[0-9A-Z]* /,"")}
/^>[0-9A-Z]*\t/ {sub (/^>[0-9A-Z]*\t/,"\t")}

$2 == "IN" { ipname = $1; shift_data(2); };

$2 == "A" { cname = tolower(sprintf ("%s.%s", $1, domainstring));
	    number = $3;
	    LINK [cname] = number;
	    append_alias(number, $1, 0);
	    append_alias(number, cname, 1);
          }
$2 == "AAAA" { cname = tolower(sprintf ("%s.%s", $1, domainstring));
	    number = $3;
	    LINK [cname] = number;
	    append_alias(number, $1, 0);
	    append_alias(number, cname, 1);
          }
$2 == "CNAME"  { 
	    cname = tolower($3); sub (/\.$/,"",cname); i= cname;
	    alias = tolower(sprintf ("%s.%s", $1, domainstring));
	    while (i in LINK) { i = LINK[i]};
	    if (match (i, /^[0-9]+\./))  # there is a host for this name
	    {
	       append_alias(i, $1, 0);
	       LINK [alias] = i;
	    }
	  };

END	  { 
	    # Output starting .... 
	    print "# from named/makezone source file " pwd "/" FILENAME ;
	    print "# at " datum ;
	    print "# ";

	    for (i in CNAME) {
	      if ((ignore_pc_X == 0) ||  
                  (! match (CNAME[i], /pc-[01234567890]*\./)))
	      {
		for (j in TMP2) delete TMP2[j];
	        nr = split (ALIAS[i], TMP1);
	        for (j=1;j<=nr;j++) 
		  TMP2[TMP1[j]]=1;
		delete ALIAS[i]; 
		for (j in TMP2) 
		{ #print "#" j "#";
		  append_alias(i, j, 0); }
                printf ("%-39s\t%s %s\n", i, CNAME[i], ALIAS[i]);
              }
	    }
          }
              

function append_alias(idx, string, type) {
	  if(string == "@") return;
	  if(substr(string, 1, 2) == "@.") string = substr(string, 3);
	  if (type == 0) 
          { if (idx in ALIAS) 
            { ALIAS[idx] = ALIAS [idx] " " string;
            }
            else { ALIAS[idx] = string; }
	  }
          else
	  { if (idx in CNAME)
            { CNAME[idx] = CNAME [idx] " " string;
	    }
            else { CNAME[idx] = string; }
	  };
  	}

function shift_data(idx) {
	  for (ffi=idx;ffi<NR;ffi++) {
	    $(ffi) = $(ffi+1);
	  };
	  $(NR) = "";
	}
	
