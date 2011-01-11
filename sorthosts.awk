#
# awk script for sorting the hosts file
# because of the braindead buggy sort utility this doesn't work
# directly (although it is supposed to do so)
#
# Author:	Christoph Weber-Fahr
#
# 1.0	initial version				sometime in June 1996
#
BEGIN	{tempfile = "sorthost.tmp";
	 tempfile2 = "sorthost2.tmp"
	}
	{ i = split ($1, ip, ".");
	  if (i == 4)
	  { printf ("number %3d %3d %3d %3d",ip[1], \
	         ip[2], ip[3], ip[4]) > tempfile;
	    for (i=2;i<=NF;i++)
	      printf (" %s", $(i)) > tempfile;
	    printf ("\n") > tempfile;
	  }
	  else
	  {print;}
	}
END	{ close (tempfile);
	  system ("sort " tempfile " > " tempfile2);
	  while (getline < tempfile2)
	  { printf ("%s.%s.%s.%s\t", $2, $3, $4, $5);
	    for (i=6;i<=NF;i++)
	      printf (" %s", $(i));
	    printf ("\n");
	  }
	  system ("rm " tempfile " " tempfile2);
	}
	
