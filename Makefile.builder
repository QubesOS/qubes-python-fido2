NO_ARCHIVE := 1

DEBIAN_BUILD_DIRS.bookworm := debian-pkg/debian
DEBIAN_BUILD_DIRS.trixie := debian-pkg/debian
DEBIAN_BUILD_DIRS := $(DEBIAN_BUILD_DIRS.$(DIST))

SOURCE_COPY_IN.debian := source-debian-copy-in
SOURCE_COPY_IN := $(SOURCE_COPY_IN.$(DISTRIBUTION))

source-debian-copy-in: VERSION = $(file <$(ORIG_SRC)/version)
source-debian-copy-in: ORIG_FILE = $(CHROOT_DIR)/$(DIST_SRC)/python-fido2_$(VERSION).orig.tar.gz
source-debian-copy-in: SRC_FILE  = $(ORIG_SRC)/fido2-$(VERSION).tar.gz
source-debian-copy-in:
	cp -p $(SRC_FILE) $(ORIG_FILE)
	tar xzf $(SRC_FILE) -C $(CHROOT_DIR)/$(DIST_SRC)/debian-pkg --strip-components=1

# vim: ft=make
