SHELL = /bin/sh

DOCKER ?= $(shell which docker)
DOCKER_REPOSITORY := graze/composer

BUILD_ARGS := --build-arg BUILD_DATE=$(shell date -u +"%Y-%m-%dT%H:%M:%SZ") \
              --build-arg VCS_REF=$(shell git rev-parse --short HEAD)

PHP_VER?=7.1
PHP_LATEST=7.1
COMPOSER_VER?=1.4.2
COMPOSER_LATEST=1.4.2

.PHONY: build build-quick test tag push deploy clean help
.PHONY: all-% php-%

.SILENT: help

default: help

build-quick: ## Build the image 🚀(quicker).
	make build options=""

all-%: ## Do the % action to all composer/php version combo's (e.g. all-build, all-test)
	make php-$* COMPOSER_VER=1.5.1
	make php-$* COMPOSER_VER=1.5.0
	make php-$* COMPOSER_VER=1.4.3
	make php-$* COMPOSER_VER=1.4.2
	make php-$* COMPOSER_VER=1.4.1
	make php-$* COMPOSER_VER=1.4.0
	make php-$* COMPOSER_VER=1.3.3
	make php-$* COMPOSER_VER=1.3.2
	make php-$* COMPOSER_VER=1.3.1
	make php-$* COMPOSER_VER=1.3.0

php-%: ## Do the % action to all php versions (e.g. php-build, php-test)
	make $* PHP_VER=7.1
	make $* PHP_VER=7.0
	make $* PHP_VER=5.6

build: options?=--no-cache --pull
build: ## Build an individual image 🚀
	${DOCKER} build ${BUILD_ARGS} --build-arg COMPOSER_VER=${COMPOSER_VER} ${options} \
		--tag ${DOCKER_REPOSITORY}:${COMPOSER_VER}-php${PHP_VER} ./php-${PHP_VER}

test: ## Test the images.
	docker run --rm -it \
		-v $$(pwd):/app \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-e PHP_VER=${PHP_VER} -e COMPOSER_VER=${COMPOSER_VER} -e CWD=$$(pwd) \
		graze/bats ./tests/graze_composer_env.bats

deploy: ## Deploy a specific version
deploy: tag push

tag: ## Tag the image with other variants
ifeq (${PHP_VER},${PHP_LATEST})
	${DOCKER} tag ${DOCKER_REPOSITORY}:${COMPOSER_VER}-php${PHP_VER} ${DOCKER_REPOSITORY}:${COMPOSER_VER}
ifeq (${COMPOSER_VER},${COMPOSER_LATEST})
	${DOCKER} tag ${DOCKER_REPOSITORY}:${COMPOSER_VER}-php${PHP_VER} ${DOCKER_REPOSITORY}:latest
endif
endif
ifeq (${COMPOSER_VER},${COMPOSER_LATEST})
	${DOCKER} tag ${DOCKER_REPOSITORY}:${COMPOSER_VER}-php${PHP_VER} ${DOCKER_REPOSITORY}:php-${PHP_VER}
endif

push:
	${DOCKER} push ${DOCKER_REPOSITORY}:${COMPOSER_VER}-php${PHP_VER}
ifeq (${PHP_VER},${PHP_LATEST})
	${DOCKER} push ${DOCKER_REPOSITORY}:${COMPOSER_VER}
ifeq (${COMPOSER_VER},${COMPOSER_LATEST})
	${DOCKER} push ${DOCKER_REPOSITORY}:latest
endif
endif
ifeq (${COMPOSER_VER},${COMPOSER_LATEST})
	${DOCKER} push ${DOCKER_REPOSITORY}:php-${PHP_VER}
endif

clean: ## Delete any images.
	${DOCKER} images --quiet graze/composer | xargs ${DOCKER} rmi -f

help: ## Show this help message.
	echo "usage: make [target] ..."
	echo ""
	echo "targets:"
	fgrep --no-filename "##" ${MAKEFILE_LIST} | fgrep --invert-match $$'\t' | sed -e 's/: ## / - /'
