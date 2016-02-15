# graze/docker-composer

A _small_ Docker image for [composer](https://getcomposer.org), a dependency management tool for PHP.

## Usage

```bash
~$ docker run --rm -it \
     -v $(pwd):/usr/src/app \
     -v ~/.composer:/root/.composer \
     -v ~/.ssh/id_rsa:/root/.ssh/id_rsa:ro \
     -v ~/.ssh/known_hosts:/root/.ssh/known_hosts:ro \
     graze/composer
```

## To-Do

- [ ] Tag for each actively maintained version of PHP (alpine currently only supports 5.6)
