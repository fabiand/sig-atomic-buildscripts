
DIST=el
RELVER=7
OVIRTVER=3.5

OBJS=ovirt-$(OVIRTVER).repo RPM-GPG-ovirt fabiand-ovirt-tree-hacks.spec-epel-7.repo

.PHONY: $(OBJS)

all: $(OBJS) centos-ovirt-host.json
	echo Done

centos-ovirt-host.json: centos-ovirt-host.json.in
	sed "s/@OVIRT_SLOT@/$(OVIRTVER)/g ; s/@DIST@/$(DIST)/g ; s/\$$releasever/$(RELVER)/g" "$@.in" > "$@"

ovirt-$(OVIRTVER).repo:
	:> "$@"
	curl "https://gerrit.ovirt.org/gitweb?p=ovirt-release.git;a=blob_plain;f=ovirt-release-$(OVIRTVER)/ovirt.repo.in;hb=HEAD" >> "$@"
	curl "https://gerrit.ovirt.org/gitweb?p=ovirt-release.git;a=blob_plain;f=ovirt-release-$(OVIRTVER)/ovirt-$(DIST)$(RELVER)-deps.repo.in;hb=HEAD" >> "$@"
	sed -i "s/@OVIRT_SLOT@/$(OVIRTVER)/g ; s/@DIST@/$(DIST)/g ; s/\$$releasever/$(RELVER)/g" "$@"

fabiand-ovirt-tree-hacks.spec-epel-7.repo:
	curl "https://copr.fedoraproject.org/coprs/fabiand/ovirt-tree-hacks.spec/repo/epel-7/fabiand-ovirt-tree-hacks.spec-epel-7.repo" >> "$@"

RPM-GPG-ovirt:
	curl -o $@ "https://gerrit.ovirt.org/gitweb?p=ovirt-release.git;a=blob_plain;f=ovirt-release-$(OVIRTVER)/RPM-GPG-ovirt;hb=HEAD"

pull: REPO=$$PWD/ostree-repo
pull:
	ostree --repo=$(REPO) init --mode=archive-z2
	ostree --repo=$(REPO) remote add --no-gpg-verify jenkins http://jenkins.ovirt.org/job/fabiand_node_ostree/ws/rpm-ostree/repo/
	ostree --repo=$(REPO) pull -v jenkins centos/7/ovirt/x86_64/host

