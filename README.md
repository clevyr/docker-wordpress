# Docker Base Images for WordPress

This repo builds base Docker base images for WordPress.

## Build

### Arguments
| Build Arg           | Description                                                                                                                                    |
|---------------------|------------------------------------------------------------------------------------------------------------------------------------------------|
| `WORDPRESS_VERSION` | WordPress version                                                                                                                              |
| `PHP_VERSION`       | PHP version                                                                                                                                    |
| `PHP_EXTENSIONS`    | Additional extensions to install (using [`mlocati/docker-php-extension-installer`](https://github.com/mlocati/docker-php-extension-installer)) |
| `FLAVOR`            | Base image type. One of `apache`,  `fpm-alpine`, or `cli`                                                                                      |
