#syntax=docker/dockerfile:1

ARG WORDPRESS_VERSION=6.7.2
ARG PHP_VERSION=8.3
ARG FLAVOR=apache

FROM ghcr.io/mlocati/php-extension-installer:2.7.24 AS ext-installer

FROM wordpress:${WORDPRESS_VERSION}-php${PHP_VERSION}-${FLAVOR}

ARG PHP_EXTENSIONS
RUN --mount=type=bind,from=ext-installer,source=/usr/bin/install-php-extensions,target=/usr/local/bin/install-php-extensions <<EOT
  install-php-extensions $PHP_EXTENSIONS
EOT
