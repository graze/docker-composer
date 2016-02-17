
# Run composer in a container.
#
# docker run --rm -it \
#     -v $(pwd):/usr/src/app \
#     -v ~/.composer:/root/.composer \
#     -v ~/.ssh/id_rsa:/root/.ssh/id_rsa:ro \
#     -v ~/.ssh/known_hosts:/root/.ssh/known_hosts:ro \
#     graze/composer

FROM alpine:3.3

MAINTAINER Samuel Parkinson <sam@graze.com>

RUN apk add --no-cache \
    ca-certificates \
    git \
    mercurial \
    subversion \
    php-cli \
    php-curl \
    php-openssl \
    php-phar \
    php-json

RUN /usr/bin/php -r "readfile('https://getcomposer.org/installer');" | \
    /usr/bin/php -- --install-dir=/usr/local/bin --filename=composer

COPY ./composer-wrapper /usr/local/bin/composer-wrapper

VOLUME ["/usr/src/app"]

WORKDIR /usr/src/app

ENTRYPOINT ["/usr/local/bin/composer-wrapper"]
