.PHONY: ovirt-3.6.repo

DIST=el
RELVER=7

ovirt-3.6.repo:
	:> "$@"
	curl "https://gerrit.ovirt.org/gitweb?p=ovirt-release.git;a=blob_plain;f=ovirt-release-3.6/ovirt.repo.in;hb=HEAD" >> "$@"
	curl "https://gerrit.ovirt.org/gitweb?p=ovirt-release.git;a=blob_plain;f=ovirt-release-3.6/ovirt-$(DIST)$(RELVER)-deps.repo.in;hb=HEAD" >> "$@"
	sed -i "s/@OVIRT_SLOT@/3.6/g ; s/@DIST@/$(DIST)/g" "$@"
