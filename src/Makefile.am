## Process this file with automake to produce Makefile.in

## Created by Anjuta


uidir = $(pkgdatadir)/ui
ui_DATA = owncloud_mount.ui


AM_CPPFLAGS = \
	-DPACKAGE_LOCALE_DIR=\""$(localedir)"\" \
	-DPACKAGE_SRC_DIR=\""$(srcdir)"\" \
	-DPACKAGE_DATA_DIR=\""$(pkgdatadir)"\" \
	$(OWNCLOUD_MOUNT_CFLAGS) \
	$(gtk+-3.0_CFLAGS) \
	$(libnotify_CFLAGS)

AM_CFLAGS =\
	 -Wall\
	 -g

bin_PROGRAMS = owncloud_mount

owncloud_mount_SOURCES = \
	owncloud_mount.vala config.vapi mounting.vala secretfileact.vala

owncloud_mount_VALAFLAGS =  \
	--pkg gtk+-3.0

owncloud_mount_LDFLAGS = \
	-Wl,--export-dynamic

owncloud_mount_LDADD = $(OWNCLOUD_MOUNT_LIBS) \
	$(gtk+-3.0_LIBS) \
	$(libnotify_LIBS)


EXTRA_DIST = $(ui_DATA)

# Remove ui directory on uninstall
uninstall-local:
	-rm -r $(uidir)
	-rm -r $(pkgdatadir)

