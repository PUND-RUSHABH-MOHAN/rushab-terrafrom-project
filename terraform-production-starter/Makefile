# Usage: make <target> ENV=dev|prod
ENV    ?= dev
TF_DIR := environments/$(ENV)
TFLINT := tflint --config "$(CURDIR)/.tflint.hcl"

.PHONY: help init fmt fmt-check validate lint scan test docs plan apply clean

help: ## Show available targets
	@grep -E '^[a-z-]+:.*## ' $(MAKEFILE_LIST) | \
	  awk 'BEGIN {FS = ":.*## "}; {printf "  %-10s %s\n", $$1, $$2}'

init: ## terraform init for ENV
	terraform -chdir=$(TF_DIR) init -input=false

fmt: ## Format every .tf file
	terraform fmt -recursive

fmt-check: ## Fail if anything is unformatted (CI)
	terraform fmt -check -recursive -diff

validate: init ## Validate ENV
	terraform -chdir=$(TF_DIR) validate

lint: ## Run tflint on all modules and environments
	$(TFLINT) --init
	$(TFLINT) --recursive --format compact

scan: ## Security scan (trivy + checkov)
	trivy config --exit-code 1 --severity HIGH,CRITICAL .
	checkov -d . --framework terraform --quiet

test: ## Run module tests (mocked, no cloud calls)
	cd modules/network && terraform init -backend=false -input=false \
	  && terraform test

docs: ## Regenerate module READMEs
	for m in modules/*/; do \
	  terraform-docs markdown table --output-file README.md \
	    --output-mode inject $$m; \
	done

plan: init ## Plan ENV, save the plan and run policy checks
	terraform -chdir=$(TF_DIR) plan -out=tfplan
	terraform -chdir=$(TF_DIR) show -json tfplan > $(TF_DIR)/tfplan.json
	conftest test $(TF_DIR)/tfplan.json --policy policy/

apply: ## Apply the saved plan for ENV
	terraform -chdir=$(TF_DIR) apply tfplan

clean: ## Remove local .terraform dirs and plan files
	find . -type d -name .terraform -prune -exec rm -rf {} +
	find . -name 'tfplan*' -delete
