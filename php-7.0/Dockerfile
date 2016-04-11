
# Run composer in a container.
#
# docker run --rm -it \
#    -v $(pwd):/usr/src/app \
#    -v ~/.composer:/home/composer/.composer \
#    -v ~/.ssh:/root/.ssh:ro \
#    graze/composer:php-7.0

FROM alpine:edge

MAINTAINER Samuel Parkinson <sam@graze.com>

RUN apk add --no-cache --repository "http://dl-cdn.alpinelinux.org/alpine/edge/testing" \
    ca-certificates \
    git \
    mercurial \
    subversion \
    php7 \
    php7-curl \
    php7-iconv \
    php7-json \
    php7-openssl \
    php7-phar \
    php7-posix

RUN php7 -r "readfile('https://getcomposer.org/installer');" | \
    php7 -- --install-dir /usr/local/bin --filename composer && \
    mkdir -p /home/composer/.composer

COPY ./composer-wrapper /usr/local/bin/composer-wrapper

ENV COMPOSER_ALLOW_SUPERUSER=1

WORKDIR /usr/src/app

VOLUME ["/home/composer/.composer"]

ENTRYPOINT ["/usr/local/bin/composer-wrapper"]
