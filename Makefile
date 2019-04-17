.PHONY: check
check: shellcheck shfmt

.PHONY: shellcheck
shellcheck: ## Checks that the shell scripts follow established lints
	shellcheck --external-sources bin/plugin

.PHONY: shfmt
shfmt: ## Checks that the shell scripts are consistently formatted
	shfmt -i 2 -ci -bn -d -l bin/plugin
