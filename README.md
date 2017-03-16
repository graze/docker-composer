# graze/docker-composer

[![Build Status](https://img.shields.io/travis/graze/docker-composer/master.svg)](https://travis-ci.org/graze/docker-composer)
[![Docker Pulls](https://img.shields.io/docker/pulls/graze/composer.svg)](https://hub.docker.com/r/graze/composer/)
[![Image Size](https://images.microbadger.com/badges/image/graze/composer.svg)](https://microbadger.com/images/graze/composer)

A _small_ Docker image for [composer](https://getcomposer.org), a dependency management tool for PHP.

## Dockerfile Links

* `php-7.1`, `php-7`, `latest` ([php-7.1/Dockerfile](https://github.com/graze/docker-composer/blob/master/php-7.1/Dockerfile))
* `php-7.0` ([php-7.0/Dockerfile](https://github.com/graze/docker-composer/blob/master/php-7.0/Dockerfile))
* `php-5.6`, `php-5` ([php-5.6/Dockerfile](https://github.com/graze/docker-composer/blob/master/php-5.6/Dockerfile))

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
