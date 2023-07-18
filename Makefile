.PHONY: help run venv install recompile
.DEFAULT_GOAL := help

help: ## Displays this help message.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

venv: ## Create a local python3.11 venv to install ansible in
	python3.11 -m venv venv
	./venv/bin/pip install --upgrade pip
	./venv/bin/pip install pip-tools

install: ## Install python requirements (assumes active environment)
	pip install -r requirements.txt

recompile: ## Regenerate explicit requirements
	pip-compile requirements.in > requirements.txt

.PHONY: password_file
password_file:
	@echo "Please enter the password for the vault file:"
	@read PASSWORD; \
	echo $$PASSWORD > .password_file

.PHONY: ansible_vaults
ansible_vaults: password_file ## Create a new vault file
	ansible-vault create inventory/group_vars/$(ENV)/vault.yml

build: ## Run the build playbook against the selected enviornment
	ansible-playbook -i inventory/$(ENV) playbooks/build.yml -v --diff

edit-vault: ## Edit encrypted variables
	ansible-vault edit inventory/group_vars/$(ENV)/vault.yml

.PHONY: update-config
update-config: ## update ".env" on remote hosts
	ansible-playbook -i inventory/$(ENV) playbooks/build.yml	\
		--tags=configure-app									\
		-v --diff
