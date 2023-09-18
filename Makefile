VERSION := $(file <version)
URL := https://github.com/Yubico/python-fido2/releases/download/$(VERSION)/fido2-$(VERSION).tar.gz
SRC_FILE = $(notdir $(URL))
UNTRUSTED_SUFF := .UNTRUSTED
SHELL := /bin/bash

ifeq ($(FETCH_CMD),)
$(error "You can not run this Makefile without having FETCH_CMD defined")
endif


keyring := python-fido2-trustedkeys.gpg
keyring-file := $(if $(GNUPGHOME), $(GNUPGHOME)/, $(HOME)/.gnupg/)$(keyring)
keyring-import := gpg -q --no-auto-check-trustdb --no-default-keyring --import

$(keyring-file): debian-pkg/debian/upstream/signing-key.asc
	@rm -f $(keyring-file) && $(keyring-import) --keyring $(keyring) $^

$(SRC_FILE).sig:
	$(FETCH_CMD) $@ $(URL).sig

%: %.sig $(keyring-file)
	$(FETCH_CMD) $@$(UNTRUSTED_SUFF) $(URL)
	@gpgv --keyring $(keyring) $< $@$(UNTRUSTED_SUFF) 2>/dev/null || \
	    { echo "Wrong signature on $@$(UNTRUSTED_SUFF)!"; exit 1; }
	@mv $@$(UNTRUSTED_SUFF) $@

%: %.sha256
	$(FETCH_CMD) $@$(UNTRUSTED_SUFF) $(URL)
	@sha256sum --status -c <(printf "$(file <$<)  -\n") <$@$(UNTRUSTED_SUFF) || \
		{ echo "Wrong SHA256 checksum on $@$(UNTRUSTED_SUFF)!"; exit 1; }
	@mv $@$(UNTRUSTED_SUFF) $@

.PHONY: get-sources
get-sources: $(SRC_FILE)

verify-sources:
	@true
