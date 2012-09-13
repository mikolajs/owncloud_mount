## Process this file with automake to produce Makefile.in
## Created by Anjuta

SUBDIRS = src 

owncloud_mountdocdir = ${prefix}/doc/owncloud_mount
owncloud_mountdoc_DATA = \
	README\
	COPYING\
	AUTHORS\
	ChangeLog\
	INSTALL\
	NEWS


EXTRA_DIST = $(owncloud_mountdoc_DATA)


# Remove doc directory on uninstall
uninstall-local:
	-rm -r $(owncloud_mountdocdir)
