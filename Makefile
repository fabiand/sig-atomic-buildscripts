.PHONY: ovirt-3.6.repo RPM-GPG-ovirt

DIST=el
RELVER=7

all: ovirt-3.6.repo RPM-GPG-ovirt
	echo Done

ovirt-3.6.repo:
	:> "$@"
	curl "https://gerrit.ovirt.org/gitweb?p=ovirt-release.git;a=blob_plain;f=ovirt-release-3.6/ovirt.repo.in;hb=HEAD" >> "$@"
	curl "https://gerrit.ovirt.org/gitweb?p=ovirt-release.git;a=blob_plain;f=ovirt-release-3.6/ovirt-$(DIST)$(RELVER)-deps.repo.in;hb=HEAD" >> "$@"
	sed -i "s/@OVIRT_SLOT@/3.6/g ; s/@DIST@/$(DIST)/g ; s/\$$releasever/$(RELVER)/g" "$@"

RPM-GPG-ovirt:
	curl -o $@ "https://gerrit.ovirt.org/gitweb?p=ovirt-release.git;a=blob_plain;f=ovirt-release-3.6/RPM-GPG-ovirt;hb=HEAD"