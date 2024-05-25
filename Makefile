SHELL := /bin/bash
# Variables
CLIFF_CONFIG = cliff.toml
CHANGELOG_FILE = CHANGELOG.md
VERSION_FILE = Cargo.toml

.PHONY: help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

lint: ## Lint the project using cargo
	@rustup component add clippy 2> /dev/null
	cargo clippy

fmt: ## Format the project using cargo
	@rustup component add rustfmt 2> /dev/null
	cargo fmt

clean: ## Clean the project using cargo
	@cargo clean

test: ## Test the project using cargo
	@cargo test

build: ## Build the project using cargo
	@cargo build

release: ## Release the project using cargo
	@cargo build --release

doc: ## Generate the documentation using cargo
	@cargo doc

changelog: ## Generate the changelog using cargo
	@if ! cargo install --list | grep -q git-cliff; then cargo install git-cliff --locked; fi
	@if ! cargo install --list | grep -q release-plz; then cargo install release-plz --locked; fi
	@if ! cargo install --list | grep -q cargo-dist; then cargo install cargo-dist --locked; fi

bump: ## Bump the version number
	@echo "Current version is $(shell cargo pkgid | cut -d# -f2)"
	@read -p "Enter new version number: " version; \
	updated_version=$$(cargo pkgid | cut -d# -f2 | sed -E "s/([0-9]+\.[0-9]+\.[0-9]+)$$/$$version/"); \
	sed -i -E "s/^version = .*/version = \"$$updated_version\"/" Cargo.toml
	@echo "New version is $(shell cargo pkgid | cut -d# -f2)"%