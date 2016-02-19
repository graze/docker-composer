
# Run composer in a container.
#
# docker run --rm -it \
#    -v $(pwd):/usr/src/app \
#    -v ~/.composer:/root/.composer \
#    -v ~/.ssh:/root/.ssh:ro \
#    graze/composer:php-5.6

FROM alpine:3.3

MAINTAINER Samuel Parkinson <sam@graze.com>

RUN apk add --no-cache \
    ca-certificates \
    git \
    mercurial \
    subversion \
    php-cli \
    php-curl \
    php-json \
    php-openssl \
    php-phar \
    php-posix

RUN /usr/bin/php -r "readfile('https://getcomposer.org/installer');" | \
    /usr/bin/php -- --install-dir=/usr/local/bin --filename=composer

COPY ./composer-wrapper /usr/local/bin/composer-wrapper

VOLUME ["/usr/src/app", "/root/.composer"]

WORKDIR /usr/src/app

ENTRYPOINT ["/usr/local/bin/composer-wrapper"]
