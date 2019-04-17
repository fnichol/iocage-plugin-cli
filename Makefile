SHUNIT2_VERSION := 2.1.7

SH_TESTS := tests/integration_test.sh
SH_SOURCES := bin/plugin $(SH_TESTS)

.PHONY: prepush
prepush: check test
	@echo "--> (prepush) passed, okay to push."

.PHONY: check
check: shellcheck shfmt

.PHONY: shellcheck
shellcheck: ## Checks that the shell scripts follow established lints
	shellcheck --external-sources $(SH_SOURCES)

.PHONY: shfmt
shfmt: ## Checks that the shell scripts are consistently formatted
	shfmt -i 2 -ci -bn -d -l $(SH_SOURCES)

.PHONY: test
test: dl-shunit2
	for test in $(SH_TESTS); do sh $$test; done

.PHONY: clean
clean:
	rm -rf tmp

.PHONY: dl-shunit2
dl-shunit2: tmp/shunit2

tmp/shunit2: tmp/shunit2-$(SHUNIT2_VERSION)
	ln -snf ./shunit2-$(SHUNIT2_VERSION) tmp/shunit2

tmp/shunit2-$(SHUNIT2_VERSION):
	mkdir -p $@
	fetch -o - https://github.com/kward/shunit2/archive/v$(SHUNIT2_VERSION).tar.gz | tar xzf - -C tmp/
