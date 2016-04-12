
# Run composer in a container.
#
# docker run --rm -it \
#    -v $(pwd):/usr/src/app \
#    -v ~/.composer:/home/composer/.composer \
#    -v ~/.ssh/id_rsa:/home/composer/.ssh/id_rsa:ro \
#    graze/composer:php-5.6

FROM alpine:3.3

MAINTAINER Samuel Parkinson <sam@graze.com>

RUN apk add --no-cache \
    ca-certificates \
    git \
    mercurial \
    openssh \
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
    mkdir -p /home/composer/.composer && \
    ln -s /root/.ssh /home/composer/.ssh

COPY ./composer-wrapper /usr/local/bin/composer-wrapper

ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /home/composer/.composer

WORKDIR /usr/src/app

VOLUME ["/home/composer/.composer"]

ENTRYPOINT ["/usr/local/bin/composer-wrapper"]
