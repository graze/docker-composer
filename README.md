# graze/docker-composer

[![Docker Stars](https://img.shields.io/docker/stars/graze/composer.svg)][hub]
[![Docker Pulls](https://img.shields.io/docker/pulls/graze/composer.svg)][hub]
[![Image Size](https://img.shields.io/imagelayers/image-size/graze/composer/latest.svg)](https://imagelayers.io/?images=graze/composer:latest)
[![Image Layers](https://img.shields.io/imagelayers/layers/graze/composer/latest.svg)](https://imagelayers.io/?images=graze/composer:latest)

A _small_ Docker image for [composer](https://getcomposer.org), a dependency management tool for PHP.

## Dockerfile Links

* `php-7.0`, `latest` ([7.0/Dockerfile](./7.0/Dockerfile))
* `php-5.6` ([5.6/Dockerfile](./5.6/Dockerfile))

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

The [Docker Hub image](https://hub.docker.com/r/graze/composer/) is an automated build that's rebuilt daily to pickup any composer updates.
