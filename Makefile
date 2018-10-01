#- makefile -
# vim: ft=make:noexpandtab:ts=2:sw=2

INITRAMDIR = /etc/initramfs-tools

all:
	echo "as root call"
	echo "	make install"

install:
	@set -e; \
	umask 022; \
	for f in hooks/* scripts/*; do \
	  [ -f "$${f}" ] || continue; \
		dir="$(INITRAMDIR)/$${f%/*}"; \
		dest="$(INITRAMDIR)/$${f}"; \
		echo "INSTALL $${f} -> $${dest}"; \
		mkdir -p "$$dir"; \
		cp -a "$$f" "$$dest"; \
		chown root: "$$dest"; \
		chmod 744 "$$dest"; \
	done

update:
	@set -e; \
	umask 022; \
	for f in hooks/* scripts/*; do \
	  [ -f "$${f}" ] || continue; \
		dir="$(INITRAMDIR)/$${f%/*}"; \
		dest="$(INITRAMDIR)/$${f}"; \
	  [ -f "$${dest}" ] || echo "SKIP $${f} (not loclly installed-> $${dest}"; \
	  [ -f "$${dest}" ] || continue; \
		echo "UPDATE $${f} -> $${dest}"; \
		mkdir -p "$$dir"; \
		cp -a "$$f" "$$dest"; \
		chown root: "$$dest"; \
		chmod 744 "$$dest"; \
	done

initramfs initrd:
	update-initramfs -k$$(uname -r) -u

diff:
	@diff -uaNr $(INITRAMDIR)/hooks   hooks   || :
	@diff -uaNr $(INITRAMDIR)/scripts scripts || :
