#- makefile -
# vim: ft=make:noexpandtab:ts=2:sw=2

INITRAMDIR = /etc/initramfs-tools

all:
	echo "as root call"
	echo "	make install"

install:
	@set -e; \
	for f in hooks/* scripts/*; do \
		dir="$(INITRAMDIR)/$${f%/*}"; \
		dest="$(INITRAMDIR)/$${f}"; \
		echo "INSTALL $${f} -> $${dest}"; \
		mkdir -p "$$dir"; \
		cp -a "$$f" "$$dest"; \
		chown root: "$$dest"; \
	done

update:
	update-initramfs -k$$(uname -r) -u
