FROM php:7.3-cli-alpine

USER root

RUN apk add --update composer git jq zip \
    curl-dev libzip-dev \
    php7-sockets php7-mbstring php7-curl php7-mysqli php7-zip && \
  docker-php-ext-install sockets && \
  docker-php-ext-configure mbstring && \
  docker-php-ext-configure curl --with-curl=/usr/include && \
  docker-php-ext-configure mysqli && \
  docker-php-ext-configure zip && \
  apk del autoconf g++ libtool make

COPY composer.json /composer.json
COPY composer.lock /composer.lock
RUN composer install --quiet

COPY package.sh /package.sh

ENTRYPOINT ["sh"]
