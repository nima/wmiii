export all_proxy := ${http_proxy}

BIN := $(wildcard bin/*)

LOCK := $(shell test -s bin/lck && echo bin/lck || which lck 2>/dev/null)
ifeq (${LOCK},)
$(error Need lck)
endif

reinstall: uninstall install secure

share:
	@touch .git/git-daemon-export-ok
	@git daemon --reuseaddr --base-path=${PWD} ${PWD}
	@rm .git/git-daemon-export-ok

install: $(foreach b,${BIN},${HOME}/${b})
	@echo "Installation complete!"

${HOME}/bin/%:
	@ln -sf $(PWD)/bin/$(@F) ${HOME}/bin/$(@F)

secure:
	@chmod 700 ${HOME}/.wmii/wmiirc
	@chmod 700 ${HOME}/.wmii/bin/*
	@chmod 700 ${HOME}/.wmii/statusbar.d/*.awk
	@chmod 700 ${HOME}/.wmii/statusbar.d/[0-9][0-9]-*
	@$(MAKE) -C ${HOME}/.wmii/statusbar.d -f Makefile.perms

uninstall:
	@$(foreach b,${BIN},rm -f ${HOME}/${b};)
	rm -f ${HOME}/bin/starty
	@echo "Uninstallation complete!"

.PHONY: install uninstall reinstall
