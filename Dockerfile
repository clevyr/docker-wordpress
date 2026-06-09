# syntax=docker/dockerfile:1

ARG WORDPRESS_VERSION=6.7.2
ARG CLI_VERSION=2.11.0
ARG PHP_VERSION=8.4
ARG FLAVOR=apache

FROM ghcr.io/mlocati/php-extension-installer:2.7.24 AS ext-installer

FROM --platform=$BUILDPLATFORM alpine AS supercronic
ARG SUPERCRONIC_VERSION=v0.2.45
ARG TARGETARCH
RUN wget -O /usr/local/bin/supercronic "https://github.com/aptible/supercronic/releases/download/${SUPERCRONIC_VERSION}/supercronic-linux-${TARGETARCH}" \
    && chmod +x /usr/local/bin/supercronic

FROM wordpress:cli-${CLI_VERSION}-php${PHP_VERSION} AS wp-cli-source

FROM wordpress:${WORDPRESS_VERSION}-php${PHP_VERSION}-${FLAVOR} AS base

FROM alpine AS config-file
RUN apk add --no-cache sd ripgrep
COPY --from=base /usr/src/wordpress/wp-config-docker.php /
RUN <<EOT
  set -eu
  match="/* Add any custom values between this line and the \"stop editing\" line. */"
  inject="require '/usr/src/clevyr/wp-config-docker.php';"
  nl=$'\n'
  rg --fixed-strings --quiet "$match" /wp-config-docker.php
  sd --fixed-strings --max-replacements=1 "$match" "${inject}${nl}${nl}${match}" /wp-config-docker.php
EOT

FROM base

COPY --from=supercronic /usr/local/bin/supercronic /usr/local/bin/supercronic
COPY --from=wp-cli-source /usr/local/bin/wp /usr/local/bin/wp
ENV WP_CLI_ALLOW_ROOT=1
ENV PAGER=cat

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

  apt-get update
  apt-get install -y s6
  rm -rf /var/lib/apt/lists/*
EOT

ENV PHP_MAX_EXECUTION_TIME=30
ENV PHP_MAX_INPUT_VARS=1000
ENV PHP_MEMORY_LIMIT=256M
ENV PHP_POST_MAX_SIZE=32M
ENV PHP_UPLOAD_MAX_FILESIZE=8M
ENV PHP_MAX_FILE_UPLOADS=20

ARG PHP_EXTENSIONS
RUN --mount=type=bind,from=ext-installer,src=/usr/bin/install-php-extensions,dst=/usr/bin/install-php-extensions <<EOT
  install-php-extensions redis $PHP_EXTENSIONS
EOT

COPY --from=config-file /wp-config-docker.php /usr/src/wordpress/wp-config-docker.php
COPY --chown=www-data:www-data wp-content /usr/src/wordpress/wp-content
COPY rootfs /

ENTRYPOINT []
CMD ["/usr/bin/s6-svscan", "/etc/s6/services"]
