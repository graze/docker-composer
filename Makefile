SHELL = /bin/sh

EXECUTABLES = docker bats jq
CHECK := $(foreach executable,$(EXECUTABLES),\
	$(if $(shell which $(executable)),"",$(error "No executable found for $(executable).")))

DOCKER ?= $(shell which docker)
DOCKER_REPOSITORY := graze/composer

BATS ?= $(shell which bats)

BUILD_ARGS := --build-arg BUILD_DATE=$(shell date -u +"%Y-%m-%dT%H:%M:%SZ") \
              --build-arg VCS_REF=$(shell git rev-parse --short HEAD)

.PHONY: build build-quick
.PHONY: test
.PHONY: tag tag-5.6 tag-7.0 tag-7.1
.PHONY: push push-5.6 push-7.0 push-7.1
.PHONY: deploy
.PHONY: clean help

.SILENT: help

default: help

build-quick: ## Build the image 🚀(quicker).
	make build options=""

build: ## Build all the images 🚀
build: build-5.6 build-7.0 build-7.1
tag: ## Tag all the images
tag: tag-5.6 tag-7.0 tag-7.1
test: ## Test all the imges
test: test-5.6 test-7.0 test-7.1
push: ## Push all the images to docker hub
push: push-5.6 push-7.0 push-7.1

build-%: options ?=--no-cache --pull
build-%: ## Build an individual image 🚀
	${DOCKER} build ${BUILD_ARGS} ${options} --tag ${DOCKER_REPOSITORY}:php-$* ./php-$*

test-%: ## Test the images.
	${BATS} ./tests/graze_composer_php-$*.bats

deploy-%: ## Deploy a specific version
	make tag-$* push-$*

tag-5.6:
	${DOCKER} tag ${DOCKER_REPOSITORY}:php-5.6 ${DOCKER_REPOSITORY}:php-5

push-5.6:
	${DOCKER} push ${DOCKER_REPOSITORY}:php-5.6
	${DOCKER} push ${DOCKER_REPOSITORY}:php-5

tag-7.0: ## Nothing to do

push-7.0:
	${DOCKER} push ${DOCKER_REPOSITORY}:php-7.0

tag-7.1:
	${DOCKER} tag ${DOCKER_REPOSITORY}:php-7.1 ${DOCKER_REPOSITORY}:php-7
	${DOCKER} tag ${DOCKER_REPOSITORY}:php-7.1 ${DOCKER_REPOSITORY}:latest

push-7.1:
	${DOCKER} push ${DOCKER_REPOSITORY}:php-7.1
	${DOCKER} push ${DOCKER_REPOSITORY}:php-7
	${DOCKER} push ${DOCKER_REPOSITORY}:latest

clean: ## Delete any images.
	${DOCKER} images --quiet graze/composer | xargs ${DOCKER} rmi -f

help: ## Show this help message.
	echo "usage: make [target] ..."
	echo ""
	echo "targets:"
	fgrep --no-filename "##" ${MAKEFILE_LIST} | fgrep --invert-match $$'\t' | sed -e 's/: ## / - /'
