# graze/docker-composer

[![Build Status](https://img.shields.io/travis/graze/docker-composer/master.svg)](https://travis-ci.org/graze/docker-composer)
[![Image Size](https://img.shields.io/imagelayers/image-size/graze/composer/latest.svg)](https://imagelayers.io/?images=graze/composer:latest)
[![Docker Pulls](https://img.shields.io/docker/pulls/graze/composer.svg)](https://hub.docker.com/r/graze/composer/)

A _small_ Docker image for [composer](https://getcomposer.org), a dependency management tool for PHP.

## Dockerfile Links

* `php-7.0`, `latest` ([php-7.0/Dockerfile](https://github.com/graze/docker-composer/blob/master/php-7.0/Dockerfile))
* `php-5.6` ([php-5.6/Dockerfile](https://github.com/graze/docker-composer/blob/master/php-5.6/Dockerfile))

## Usage

```bash
~$ docker run --rm -it \
   -v $(pwd):/usr/src/app \
   -v ~/.composer:/root/.composer \
   -v ~/.ssh:/root/.ssh:ro \
   graze/composer
```

## Image Updates

The Docker Hub image ([graze/composer](https://hub.docker.com/r/graze/composer/)) is an automated build that's also rebuilt daily to pickup any composer updates.

The image is _only_ based of the [composer/composer](https://github.com/composer/composer) master branch, until releases (^1.0, etc.) are actively updated with security fixes.
