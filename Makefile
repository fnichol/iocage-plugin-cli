SH_TESTS := $(shell find tests -type f -name '*_test.sh')

NAME := iocage-plugin-cli
REPO := https://github.com/fnichol/iocage-plugin-cli

include vendor/mk/base.mk
include vendor/mk/shell.mk
include vendor/mk/release.mk

build: build/plugin ## Builds the sources
.PHONY: build

test: build/plugin test-shell ## Runs all tests
.PHONY: test

check: check-shell ## Checks all linting, styling, & other rules
.PHONY: check

clean: clean-shell ## Cleans up project
	rm -rf build
.PHONY: clean

build/plugin: bin/plugin.sh
	@echo "--- $@"
	mkdir -p build
	awk \
		-v NIGHTLY_BUILD="$${NIGHTLY_BUILD:-}" \
		-f support/compile.awk $< > $@
	chmod 0755 $@
