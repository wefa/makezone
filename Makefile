SAVEPATH=/dat/sicher/namedb-example
SAVEHOST=192.168.51.1
FTPPATH=/dat/sicher/conf

SAVESCRIPT=./tftpout.sh

SCRIPTS=Makefile makezone beautify.awk $(SAVESCRIPT) make-localhost \
	makehosts.awk sorthosts.awk reload
CONFS=named.conf named.root PROTO.localhost.rev

SRCS=example.src

ALLSRCES=$(SRCS) $(CONFS) $(SCRIPTS) 

AWK=/usr/bin/awk

.SUFFIXES: .out .saved .sav
.NULL:	.out
.PATH: /etc/namedb/


all: nameserver hosts backup

.out.sav:
	${SAVESCRIPT} ${.IMPSRC} $(SAVEHOST)
	cp $(.IMPSRC) $(SAVEPATH)
	touch ${.TARGET}

localhost.rev: PROTO.localhost.rev /etc/rc.conf make-localhost Makefile
	sh make-localhost

nameserver: db.example Makefile $(CONFS)
	./reload
	touch nameserver

db.example: example.src $(SCRIPTS)
	cp example.src example.src.old
	./makezone -short example.src \
		-f lab.example.org                            db.org.example.lab                           \
		-f sub.lab.example.org                        db.org.example.lab.sub                       \
		-r 192.0.2.0/24                               db.192.0.2.0.24                              \
		-r 192.0.3.0/26                               db.192.0.3.0.26                              \
		-r 192.1.0.0/22                               db.192.1.0.0.22                              \
		-r 2001:db8:1234::/48                         db.2001.0db8.1234..48                        \
		-r 2001:db8:1234:4242::/64                    db.2001.0db8.1234.4242..64                   \
		-r 2001:db8:1234:7778::/61                    db.2001.0db8.1234.7778..61                   \
		-r 2001:db8:1234:7778:1111:2222:3333:4444/126 2001.0db8.1234.7778.1111.2222.3333.4444..126


hosts:  $(SRCS) makehosts.awk sorthosts.awk Makefile
	$(AWK) -f makehosts.awk $(SRCS) \
	| $(AWK) -f sorthosts.awk > hosts
	cp hosts $(FTPPATH)
	chmod go+r $(FTPPATH)/hosts
	cp hosts /etc/hosts-full
	chmod go+r /etc/hosts-full

backup: $(ALLSRCES:C/\$/.sav/) 

#backup: $(ALLSRCES:C/(.*)/saveflags\/\1.sav/) 

test:
	cd tests && sh run-test.sh
