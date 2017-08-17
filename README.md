# graze/docker-composer

[![Build Status](https://img.shields.io/travis/graze/docker-composer/master.svg)](https://travis-ci.org/graze/docker-composer)
[![Docker Pulls](https://img.shields.io/docker/pulls/graze/composer.svg)](https://hub.docker.com/r/graze/composer/)
[![Image Size](https://images.microbadger.com/badges/image/graze/composer.svg)](https://microbadger.com/images/graze/composer)

A _small_ Docker image for [composer](https://getcomposer.org), a dependency management tool for PHP.

## Images

This repository generates an image for each composer version, php version and combination thereof

The available composer versions are:

* `1.5.1`, `latest`
* `1.5.0`
* `1.4.3`
* `1.4.2`
* `1.4.1`
* `1.4.0`
* `1.3.3`
* `1.3.2`
* `1.3.1`
* `1.3.0`

The available php versions are:

* `php-7.1`, `latest` ([php-7.1/Dockerfile](https://github.com/graze/docker-composer/blob/master/php-7.1/Dockerfile))
* `php-7.0` ([php-7.0/Dockerfile](https://github.com/graze/docker-composer/blob/master/php-7.0/Dockerfile))
* `php-5.6` ([php-5.6/Dockerfile](https://github.com/graze/docker-composer/blob/master/php-5.6/Dockerfile))

Combination images are in the format: `{composer_ver}-php{php_ver}`

* `1.4.1-php7.1`
* `1.4.0-php5.6`
* etc...

## Usage

```bash
~$ docker run --rm -it \
    -v $(pwd):/usr/src/app \
    -v ~/.composer:/home/composer/.composer \
    -v ~/.ssh/id_rsa:/home/composer/.ssh/id_rsa:ro \
   graze/composer
```

## Image Updates

The Docker Hub image ([graze/composer](https://hub.docker.com/r/graze/composer/)) is an automated build that's also rebuilt daily to pickup any composer updates.

## Development

You can build an individual image with:

```bash
~$ PHP_VER=7.1 COMPOSER_VER=1.4.1 make build
```

or build and test all images with:
```bash
~$ make all-build all-test
```
