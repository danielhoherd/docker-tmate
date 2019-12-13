CONTAINER_NAME = tmate
PORT ?= 2200

.PHONY: help
help: ## Print Makefile help.
	@grep -Eh '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-14s\033[0m %s\n", $$1, $$2}'

.PHONY: install-hooks
install-hooks: ## Install git hooks.
	command -v pre-commit || pip3 install --user --upgrade pre-commit
	pre-commit install -f --install-hooks

.PHONY: keys
keys: keys/ssh_host_ed25519_key ## Create tmate server keys.
keys/ssh_host_ed25519_key:
	./create_keys.sh

.PHONY: restart
restart: stop run ## Restart the running container.

.PHONY: stop
stop: ## Stop running container.
	docker stop ${CONTAINER_NAME}

.PHONY: run
run: keys ## Run a local tmate server.
	docker run \
		--name=${CONTAINER_NAME} \
		--rm \
		--detach \
		--mount "type=bind,src=${PWD}/keys,dst=/keys" \
		--publish ${PORT}:2200 \
		--env SSH_KEYS_PATH=/keys \
		--cap-add SYS_ADMIN \
		tmate/tmate-ssh-server

.PHONY: clean
clean: stop ## Stop container and delete generated content.
	rm -rf keys tmate.conf
