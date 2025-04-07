#syntax=docker/dockerfile:1

ARG WORDPRESS_VERSION=6.7.2
ARG CLI_VERSION=2.11.0
ARG PHP_VERSION=8.4
ARG FLAVOR=apache

FROM ghcr.io/mlocati/php-extension-installer:2.7.24 AS ext-installer

FROM wordpress:cli-${CLI_VERSION}-php${PHP_VERSION} AS wp-cli-source

FROM wordpress:${WORDPRESS_VERSION}-php${PHP_VERSION}-${FLAVOR} AS base

# Disable short tags
RUN echo 'short_open_tag=Off' >> /usr/local/etc/php/conf.d/custom-php.ini

COPY --from=wp-cli-source /usr/local/bin/wp /usr/local/bin/wp
RUN chmod +x /usr/local/bin/wp

RUN mkdir -p /var/www/.wp-cli/cache && \
    chown -R www-data:www-data /var/www/.wp-cli

ARG WP_CLI_ALLOW_ROOT=1
ENV WP_CLI_ALLOW_ROOT=$WP_CLI_ALLOW_ROOT

COPY --from=ext-installer /usr/bin/install-php-extensions /usr/local/bin/install-php-extensions

ARG PHP_EXTENSIONS
ONBUILD RUN install-php-extensions $PHP_EXTENSIONS
