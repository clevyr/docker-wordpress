#syntax=docker/dockerfile:1

ARG WORDPRESS_VERSION=6.7.2
ARG CLI_VERSION=2.11.0
ARG PHP_VERSION=8.4
ARG FLAVOR=apache

FROM ghcr.io/mlocati/php-extension-installer:2.7.24 AS ext-installer

FROM wordpress:cli-${CLI_VERSION}-php${PHP_VERSION} AS wp-cli-source

FROM wordpress:${WORDPRESS_VERSION}-php${PHP_VERSION}-${FLAVOR} AS base

COPY --from=wp-cli-source /usr/local/bin/wp /usr/local/bin/wp
ARG WP_CLI_ALLOW_ROOT=1
ENV WP_CLI_ALLOW_ROOT=$WP_CLI_ALLOW_ROOT

RUN <<EOT
  set -eux

  mkdir -p /var/www/.wp-cli/cache
  chown -R www-data:www-data /var/www/.wp-cli

  cd "$PHP_INI_DIR"

  sed -ri \
      -e 's/^;?(max_execution_time).*/\1 = ${PHP_MAX_EXECUTION_TIME}/' \
      -e 's/^;?(max_input_vars).*/\1 = ${PHP_MAX_INPUT_VARS}/' \
      -e 's/^;?(memory_limit).*/\1 = ${PHP_MEMORY_LIMIT}/' \
      -e 's/^;?(post_max_size).*/\1 = ${PHP_POST_MAX_SIZE}/' \
      -e 's/^;?(upload_max_filesize).*/\1 = ${PHP_UPLOAD_MAX_FILESIZE}/' \
      -e 's/^;?(max_file_uploads).*/\1 = ${PHP_MAX_FILE_UPLOADS}/' \
      -e 's/^;?(expose_php).*/\1 = Off/' \
      php.ini-production

  ln -s php.ini-production php.ini
EOT

ONBUILD ARG PHP_MAX_EXECUTION_TIME
ONBUILD ENV PHP_MAX_EXECUTION_TIME=${PHP_MAX_EXECUTION_TIME:-30}
ONBUILD ARG PHP_MAX_INPUT_VARS
ONBUILD ENV PHP_MAX_INPUT_VARS=${PHP_MAX_INPUT_VARS:-1000}
ONBUILD ARG PHP_MEMORY_LIMIT
ONBUILD ENV PHP_MEMORY_LIMIT=${PHP_MEMORY_LIMIT:-256M}
ONBUILD ARG PHP_POST_MAX_SIZE
ONBUILD ENV PHP_POST_MAX_SIZE=${PHP_POST_MAX_SIZE:-32M}
ONBUILD ARG PHP_UPLOAD_MAX_FILESIZE
ONBUILD ENV PHP_UPLOAD_MAX_FILESIZE=${PHP_UPLOAD_MAX_FILESIZE:-8M}
ONBUILD ARG PHP_MAX_FILE_UPLOADS
ONBUILD ENV PHP_MAX_FILE_UPLOADS=${PHP_MAX_FILE_UPLOADS:-20}

COPY --from=ext-installer /usr/bin/install-php-extensions /usr/local/bin/install-php-extensions

ARG PHP_EXTENSIONS
ONBUILD RUN install-php-extensions $PHP_EXTENSIONS
