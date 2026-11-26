SHELL := /bin/bash
.DEFAULT_GOAL := help

.PHONY: help check

help: ## List every target
	@awk 'BEGIN {FS = ":.*## "} /^[a-zA-Z0-9_-]+:.*## / {printf "  %-10s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

check: ## Verify the baseline documents and defaults
	@bash scripts/check.sh
