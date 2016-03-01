SHELL = /bin/sh

DOCKER ?= $(shell which docker)
DOCKER_REPOSITORY := graze/composer

BATS ?= $(shell which bats)

EXECUTABLES = docker bats
CHECK := $(foreach executable,$(EXECUTABLES),\
	$(if $(shell which $(executable)),"",$(error "No executable found for $(executable).")))

.PHONY: images test clean help

.SILENT: help

default: help

images: ## Build the image 🚀.
	${DOCKER} build --pull -t ${DOCKER_REPOSITORY}:latest ./php-7.0
	${DOCKER} build --pull -t ${DOCKER_REPOSITORY}:php-7.0 ./php-7.0
	${DOCKER} build --pull -t ${DOCKER_REPOSITORY}:php-5.6 ./php-5.6

test: ## Test the images.
	${BATS} ./tests/graze_composer_latest.bats
	${BATS} ./tests/graze_composer_php-7.0.bats
	${BATS} ./tests/graze_composer_php-5.6.bats

clean: ## Delete any images.
	${DOCKER} images --quiet graze/composer | xargs ${DOCKER} rmi -f

help: ## Show this help message.
	echo "usage: make [target] ..."
	echo ""
	echo "targets:"
	fgrep --no-filename "##" ${MAKEFILE_LIST} | fgrep --invert-match $$'\t' | sed -e 's/: ## / - /'
