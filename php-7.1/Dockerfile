
# Run composer in a container.
#
# docker run --rm -it \
#    -v $(pwd):/usr/src/app \
#    -v ~/.composer:/home/composer/.composer \
#    -v ~/.ssh/id_rsa:/home/composer/.ssh/id_rsa:ro \
#    graze/composer:php-7.1

FROM alpine:edge

LABEL maintainer="developers@graze.com" \
    license="MIT" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.vendor="graze" \
    org.label-schema.name="composer" \
    org.label-schema.description="alpine composer image" \
    org.label-schema.vcs-url="https://github.com/graze/docker-composer"

RUN apk add --no-cache -u --repository "http://dl-cdn.alpinelinux.org/alpine/edge/testing" \
    ca-certificates \
    git \
    mercurial \
    openssh-client \
    subversion \
    php7.1 \
    php7.1-ctype \
    php7.1-curl \
    php7.1-iconv \
    php7.1-json \
    php7.1-openssl \
    php7.1-phar \
    php7.1-posix \
    php7.1-zlib

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
