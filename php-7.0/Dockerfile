
# Run composer in a container.
#
# docker run --rm -it \
#     -v $(pwd):/usr/src/app \
#     -v ~/.composer:/root/.composer \
#     -v ~/.ssh/id_rsa:/root/.ssh/id_rsa:ro \
#     -v ~/.ssh/known_hosts:/root/.ssh/known_hosts:ro \
#     graze/composer

FROM alpine:edge

MAINTAINER Samuel Parkinson <sam@graze.com>

RUN echo "http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk add --no-cache \
    ca-certificates \
    git \
    mercurial \
    subversion \
    php7 \
    php7-curl \
    php7-openssl \
    php7-phar \
    php7-json

RUN /usr/bin/php7 -r "readfile('https://getcomposer.org/installer');" | \
    /usr/bin/php7 -- --install-dir=/usr/local/bin --filename=composer

COPY ./composer-wrapper /usr/local/bin/composer-wrapper

VOLUME ["/usr/src/app"]

WORKDIR /usr/src/app

ENTRYPOINT ["/usr/local/bin/composer-wrapper"]
