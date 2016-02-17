# graze/docker-composer [![Build Status](https://img.shields.io/travis/graze/docker-composer/master.svg)](https://travis-ci.org/graze/docker-composer)

[![Image Size](https://img.shields.io/imagelayers/image-size/graze/composer/latest.svg)](https://imagelayers.io/?images=graze/composer:latest)
[![Docker Pulls](https://img.shields.io/docker/pulls/graze/composer.svg)](https://hub.docker.com/r/graze/composer/)

A _small_ Docker image for [composer](https://getcomposer.org), a dependency management tool for PHP.

## Dockerfile Links

* `php-7.0`, `latest` ([php-7.0/Dockerfile](./php-7.0/Dockerfile))
* `php-5.6` ([php-5.6/Dockerfile](./php-5.6/Dockerfile))

## Usage

```bash
~$ docker run --rm -it \
     -v $(pwd):/usr/src/app \
     -v ~/.composer:/root/.composer \
     -v ~/.ssh/id_rsa:/root/.ssh/id_rsa:ro \
     -v ~/.ssh/known_hosts:/root/.ssh/known_hosts:ro \
     graze/composer
```

## Image Updates

The [Docker Hub image](https://hub.docker.com/r/graze/composer/) is an automated build that's also rebuilt daily to pickup any composer updates.
