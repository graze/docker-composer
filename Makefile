SHELL = /bin/sh

DOCKER ?= $(shell which docker)
DOCKER_REPOSITORY := graze/composer
DOCKER_TAG := latest

.PHONY: install clean help

.SILENT: help

image: ## Build the image 🚀.
	${DOCKER} build --pull -t ${DOCKER_REPOSITORY}:${DOCKER_TAG} .

clean: ## Delete any images.
	${DOCKER} images --quiet graze/composer | xargs ${DOCKER} rmi

help: ## Show this help message.
	echo "usage: make [target] ..."
	echo ""
	echo "targets:"
	fgrep --no-filename "##" ${MAKEFILE_LIST} | fgrep --invert-match $$'\t' | sed -e 's/: ## / - /'
