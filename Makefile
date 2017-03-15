SHELL = /bin/sh

EXECUTABLES = docker bats jq
CHECK := $(foreach executable,$(EXECUTABLES),\
	$(if $(shell which $(executable)),"",$(error "No executable found for $(executable).")))

DOCKER ?= $(shell which docker)
DOCKER_REPOSITORY := graze/composer

BATS ?= $(shell which bats)

.PHONY: images test clean help

.SILENT: help

default: help

images-quick: ## Build the image 🚀(quicker).
	make images options=""

images: options ?=--no-cache --pull
images: ## Build the image 🚀.
	${DOCKER} build ${options} --tag ${DOCKER_REPOSITORY}:latest \
		--tag ${DOCKER_REPOSITORY}:php-7.1 \
		--tag ${DOCKER_REPOSITORY}:php-7 ./php-7.1
	${DOCKER} build ${options} --tag ${DOCKER_REPOSITORY}:php-7.0 ./php-7.0
	${DOCKER} build ${options} --tag ${DOCKER_REPOSITORY}:php-5.6 \
		 --tag ${DOCKER_REPOSITORY}:php-5 ./php-5.6

test: ## Test the images.
	${BATS} -t ./tests/graze_composer_latest.bats
	${BATS} -t ./tests/graze_composer_php-7.1.bats
	${BATS} -t ./tests/graze_composer_php-7.0.bats
	${BATS} -t ./tests/graze_composer_php-5.6.bats

clean: ## Delete any images.
	${DOCKER} images --quiet graze/composer | xargs ${DOCKER} rmi -f

help: ## Show this help message.
	echo "usage: make [target] ..."
	echo ""
	echo "targets:"
	fgrep --no-filename "##" ${MAKEFILE_LIST} | fgrep --invert-match $$'\t' | sed -e 's/: ## / - /'
