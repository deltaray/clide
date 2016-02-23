# clide
# Copyright (C) 2010 Mark Krenz

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# You may contact the author at <mark@suso.com>

VERSION	= $(shell cat VERSION)
PROJECT	= clide
DIST	= $(PROJECT)-$(VERSION)
FILES	= $(shell cat MANIFEST)
UTILS	= clide
DOCS	= CHANGELOG COPYING LICENSE MANIFEST README.md GOALS WARNING
TESTS	= alphabet strings
# rpm --showrc is gettin to be hard to parse anymore.
#RPMDIR	= /usr/src/redhat  
RPMDIR	= $(shell rpm --showrc | grep " _topdir" | \
	perl -n -e \
	'/_topdir(?:\s+|\s+:\s+)(\/.*|%{_usrsrc}.*$$)/; \
	$$dir = $$1; $$dir =~ s|%{_usrsrc}|/usr/src|; print "$$1\n";')

# Modify these as nessecary
ROOT    = /
DESTDIR = $(ROOT)
PERL	= /usr/bin/perl
BINDIR	= $(DESTDIR)/usr/bin
TOPDIR	= $(DESTDIR)/usr
MANDIR	= $(TOPDIR)/share/man/man1
DOCDIR	= $(TOPDIR)/share/doc/$(DIST)
BINDIR	= $(TOPDIR)/bin
TARFILE	= $(DIST).tar.gz
RPMFILE	= $(RPMDIR)
SPECFILE= $(PROJECT).spec
RPMFILE	= $(RPMDIR)/RPMS/noarch/$(DIST)-1.noarch.rpm
SRPMFILE= $(RPMDIR)/SRPMS/$(DIST)-1.src.rpm


all: manpages
	for file in $(UTILS) ; do \
		cat $$file | sed 's|^#!/usr/bin/perl|#!$(PERL)|' > $$file.out ; \
		mv $$file.out $$file ; chmod a+x $$file ; done

install:
	install -m 0755 -o 0 -g 0 -d		$(BINDIR)
	for util in $(UTILS) ; do \
	    install -m 0755 -o 0 -g 0 $$util	$(BINDIR) ; done

	install -m 0755 -o 0 -g 0 -d		$(DOCDIR)
	for doc in $(DOCS) ; do \
	    install -m 0644 -o 0 -g 0 $$doc	$(DOCDIR) ; done

	install -m 0755 -o 0 -g 0 -d		$(MANDIR)
	for man in $(UTILS) ; do \
		install -m 0644 -o 0 -g 0 $$man.1.gz $(MANDIR) ; done

uninstall:
	for util in $(UTILS) ; do \
		rm -f $(BINDIR)/$$util ; done
	rmdir $(BINDIR)

	for doc in $(DOCS) ; do \
		rm -f $(DOCDIR)/$$doc ; done
	rmdir $(DOCDIR)

	for man in $(UTILS) ; do \
		rm -f $(MANDIR)/$$man.1.gz ; done
	rmdir $(MANDIR)

manpages:
	for doc in $(UTILS) ; do \
		pod2man $$doc > $$doc.1 ; \
		gzip $$doc.1 ; chmod 644 $$doc.1.gz \
		; done

rpminstall:
	install -m 0755 -d		$(BINDIR)
	for util in $(UTILS) ; do \
	    install -m 0755 $$util	$(BINDIR) ; done

	install -m 0755 -d		$(DOCDIR)
	for doc in $(DOCS) ; do \
	    install -m 0644 $$doc	$(DOCDIR) ; done

	install -m 0755 -d		$(MANDIR)
	for man in $(UTILS) ; do \
		install -m 0644 $$man.1.gz $(MANDIR) ; done

clean:
	rm -f $(PROJECT).spec
	rm -f $(TARFILE)
	for file in $(UTILS) ; do \
	    rm -f $$file.1.gz ; done
	for file in $(UTILS) ; do \
		cat $$file | sed 's|^#!$(PERL)|#!/usr/bin/perl|' > $$file.out ; \
		mv $$file.out $$file ; chmod a+x $$file ; done

dist: $(TARFILE)


test:
	for file in $(UTILS) ; do $(PERL) -Tcw $$file ; done

$(TARFILE): $(FILES)
	rm -fr $(DIST)
	rm -f $(TARFILE)
	mkdir $(DIST)
	perl -pe 'chomp; symlink "../$$_", "$(DIST)/$$_" or die $$!' MANIFEST
	tar zchf $(DIST).tar.gz $(DIST) --exclude .git
	rm -r $(DIST)

rpm: $(RPMFILE) $(SRPMFILE)

$(RPMFILE): do-rpm

$(SRPMFILE): do-rpm

do-rpm: $(TARFILE) $(SPECFILE)
	cp $(SPECFILE) $(RPMDIR)/SPECS/
	cp $(TARFILE) $(RPMDIR)/SOURCES/
	rpmbuild -ba $(RPMDIR)/SPECS/$(SPECFILE)

$(SPECFILE): $(SPECFILE).in VERSION
	perl -pe 's[\@(\S+)\@] [open F, $$1 or die; $$x = join "", <F>; chomp $$x; $$x]ge' < $< > $@

