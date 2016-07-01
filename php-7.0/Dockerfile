
# Run composer in a container.
#
# docker run --rm -it \
#    -v $(pwd):/usr/src/app \
#    -v ~/.composer:/home/composer/.composer \
#    -v ~/.ssh/id_rsa:/home/composer/.ssh/id_rsa:ro \
#    graze/composer:php-7.0

FROM alpine:edge

MAINTAINER Samuel Parkinson <samuel.parkinson@ft.com>

RUN apk add --no-cache --repository "http://dl-cdn.alpinelinux.org/alpine/edge/testing" \
    ca-certificates \
    git \
    mercurial \
    openssh \
    subversion \
    php7 \
    php7-ctype \
    php7-curl \
    php7-iconv \
    php7-json \
    php7-openssl \
    php7-phar \
    php7-posix

RUN php7 -r "readfile('https://getcomposer.org/installer');" | \
    php7 -- --install-dir /usr/local/bin --filename composer && \
    mkdir -p /home/composer/.composer && \
    ln -s /root/.ssh /home/composer/.ssh

COPY ./composer-wrapper /usr/local/bin/composer-wrapper

ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /home/composer/.composer

WORKDIR /usr/src/app

VOLUME ["/home/composer/.composer"]

ENTRYPOINT ["/usr/local/bin/composer-wrapper"]
