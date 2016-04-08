
# Run composer in a container.
#
# docker run --rm -it \
#    -v $(pwd):/usr/src/app \
#    -v ~/.composer:/home/composer/.composer \
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
    php-iconv \
    php-json \
    php-openssl \
    php-phar \
    php-posix

RUN php -r "readfile('https://getcomposer.org/installer');" | \
    php -- --install-dir /usr/local/bin --filename composer && \
    mkdir -p /home/composer/.composer

COPY ./composer-wrapper /usr/local/bin/composer-wrapper

ENV COMPOSER_ALLOW_SUPERUSER=1

WORKDIR /usr/src/app

VOLUME ["/home/composer/.composer"]

ENTRYPOINT ["/usr/local/bin/composer-wrapper"]
