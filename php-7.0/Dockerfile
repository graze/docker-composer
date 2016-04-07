
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

RUN /usr/bin/wget -qO - https://getcomposer.org/installer | \
    /usr/bin/php7 -- --install-dir /usr/local/bin --filename composer

COPY ./composer-wrapper /usr/local/bin/composer-wrapper

RUN adduser -D -S -s /bin/false composer

USER composer

VOLUME ["/usr/src/app", "/home/composer/.composer"]

WORKDIR /usr/src/app

ENTRYPOINT ["/usr/local/bin/composer-wrapper"]
