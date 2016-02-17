SHELL = /bin/sh

DOCKER ?= $(shell which docker)
DOCKER_REPOSITORY := graze/composer

.PHONY: images clean help

.SILENT: help

images: ## Build the image 🚀.
	${DOCKER} build --pull -t ${DOCKER_REPOSITORY}:latest ./php-7.0
	${DOCKER} build --pull -t ${DOCKER_REPOSITORY}:php-7.0 ./php-7.0
	${DOCKER} build --pull -t ${DOCKER_REPOSITORY}:php-5.6 ./php-5.6

clean: ## Delete any images.
	${DOCKER} images --quiet graze/composer | xargs ${DOCKER} rmi -f

help: ## Show this help message.
	echo "usage: make [target] ..."
	echo ""
	echo "targets:"
	fgrep --no-filename "##" ${MAKEFILE_LIST} | fgrep --invert-match $$'\t' | sed -e 's/: ## / - /'
