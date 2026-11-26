SHELL := /bin/bash
.DEFAULT_GOAL := help

.PHONY: help dev test check repo-check

help: ## List every target
	@awk 'BEGIN {FS = ":.*## "} /^[a-zA-Z0-9_-]+:.*## / {printf "  %-12s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

dev: ## Run it locally
	@echo "TODO: replace with the real command"

test: ## Run the test suite
	@echo "TODO: replace with the real command"

check: ## The gate: format, lint, tests, then the repository check
	@echo "TODO: run format and lint"
	@$(MAKE) --no-print-directory test
	@$(MAKE) --no-print-directory repo-check

repo-check: ## Verify the baseline files and workflows
	@bash scripts/check-repo.sh
