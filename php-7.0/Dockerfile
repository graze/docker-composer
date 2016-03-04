
# Run composer in a container.
#
# docker run --rm -it \
#    -v $(pwd):/usr/src/app \
#    -v ~/.composer:/root/.composer \
#    -v ~/.ssh:/root/.ssh:ro \
#    graze/composer:php-7.0

FROM alpine:edge

MAINTAINER Samuel Parkinson <sam@graze.com>

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk add --no-cache \
    ca-certificates \
    git \
    mercurial \
    subversion \
    php7 \
    php7-curl \
    php7-json \
    php7-openssl \
    php7-phar \
    php7-posix

RUN /usr/bin/php7 -r "readfile('https://getcomposer.org/installer');" | \
    /usr/bin/php7 -- --install-dir=/usr/local/bin --filename=composer

COPY ./composer-wrapper /usr/local/bin/composer-wrapper

VOLUME ["/usr/src/app", "/root/.composer"]

WORKDIR /usr/src/app

ENTRYPOINT ["/usr/local/bin/composer-wrapper"]
