#- makefile -
# vim: ft=make:noexpandtab:ts=2:sw=2

INITRAMDIR = /etc/initramfs-tools

all: help

help:
	@echo
	@echo "	 make install - install all files"
	@echo "	 make update  - updated newer files"
	@echo "	 make diff    - shows differences between repository and local files"
	@echo "	 make initrd  - generates new initramdisks"
	@echo

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
	  [ -f "$${dest}" ] || continue; \
		cmp -b "$${dest}" "$${f}" > /dev/null && continue || :; \
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
