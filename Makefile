.PHONY: ovirt-3.5.repo RPM-GPG-ovirt

DIST=el
RELVER=7

all: ovirt-3.5.repo RPM-GPG-ovirt
	echo Done

ovirt-3.5.repo:
	:> "$@"
	curl "https://gerrit.ovirt.org/gitweb?p=ovirt-release.git;a=blob_plain;f=ovirt-release-3.5/ovirt.repo.in;hb=HEAD" >> "$@"
	curl "https://gerrit.ovirt.org/gitweb?p=ovirt-release.git;a=blob_plain;f=ovirt-release-3.5/ovirt-$(DIST)$(RELVER)-deps.repo.in;hb=HEAD" >> "$@"
	sed -i "s/@OVIRT_SLOT@/3.5/g ; s/@DIST@/$(DIST)/g ; s/\$$releasever/$(RELVER)/g" "$@"

RPM-GPG-ovirt:
	curl -o $@ "https://gerrit.ovirt.org/gitweb?p=ovirt-release.git;a=blob_plain;f=ovirt-release-3.5/RPM-GPG-ovirt;hb=HEAD"

pull: REPO=$$PWD/ostree-repo
pull:
	ostree --repo=$(REPO) init --mode=archive-z2
	ostree --repo=$(REPO) remote add --no-gpg-verify jenkins http://jenkins.ovirt.org/job/fabiand_node_ostree/ws/rpm-ostree/repo/
	ostree --repo=$(REPO) pull -v jenkins centos/7/ovirt/x86_64/host

