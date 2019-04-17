SHUNIT2_VERSION := 2.1.7

SH_TESTS := `find tests -name '*_test.sh'`
SH_SOURCES := bin/plugin tests/test_helpers.sh $(SH_TESTS)

.PHONY: prepush
prepush: check test
	@echo "--> (prepush) passed, okay to push."

.PHONY: check
check: shellcheck shfmt

.PHONY: shellcheck
shellcheck: ## Checks that the shell scripts follow established lints
	# In order to leave relative paths for shellcheck to follow external sources,
	# we will set the `$PWD` for each shellcheck call to be relative to the
	# source file. However, now the directory information is lost on error, so we
	# will compute and use an absolute path to the source file when invoking
	# shellcheck--I would love a better alternative here...
	for rel_src in $(SH_SOURCES); do \
		(abs_src=`stat -f%R $$rel_src` \
			&& cd `dirname $$rel_src` \
			&& shellcheck --external-sources $$abs_src); \
	done

.PHONY: shfmt
shfmt: ## Checks that the shell scripts are consistently formatted
	shfmt -i 2 -ci -bn -d -l $(SH_SOURCES)

.PHONY: test
test: dl-shunit2
	for test in $(SH_TESTS); do echo; echo "Running: $$test"; sh $$test; done

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
