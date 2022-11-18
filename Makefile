
.PHONY: init
init: ## Initialize terraform local env
	tfenv install
	gcloud auth application-default login
	cd dev && terraform init
	cd prod && terraform init

.PHONY: fmt
fmt: ## Format code
	terraform fmt -recursive

.PHONY: dev-plan
dev-plan: ## Show changes in dev
	cd dev && terraform plan

.PHONY: prod-plan
prod-plan: ## Show changes in prod
	cd prod && terraform plan

.PHONY: help
help: ## list commands
	@echo "Available commands: "
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'
