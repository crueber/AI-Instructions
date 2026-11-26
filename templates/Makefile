SHELL := /bin/bash
.DEFAULT_GOAL := help

.PHONY: help dev fmt fmt-check lint test test-slow bench build check repo-check release publish

help: ## List every target
	@awk 'BEGIN {FS = ":.*## "} /^[a-zA-Z0-9_-]+:.*## / {printf "  %-12s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

dev: ## Run it locally
	@echo "TODO: replace with the real command"

fmt: ## Format the code
	@echo "TODO: replace with the real command"

fmt-check: ## Fail if the code is not formatted
	@echo "TODO: replace with the real command"

lint: ## Run the linter
	@echo "TODO: replace with the real command"

test: ## Run the unit and contract tests
	@echo "TODO: replace with the real command"

test-slow: ## Run the slow tests (nightly)
	@echo "TODO: replace with the real command"

bench: ## Run the benchmarks (nightly)
	@echo "TODO: replace with the real command"

build: ## Build the artifact
	@echo "TODO: replace with the real command"

check: fmt-check lint test repo-check ## The gate: format, lint, tests, repository check

repo-check: ## Verify the baseline files and workflows
	@bash scripts/check-repo.sh

release: ## Build dist/ and SHA256SUMS from the tag
	@echo "TODO: write dist/ and SHA256SUMS"

publish: ## Publish the release
	@echo "TODO: publish the release"
