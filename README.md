# Docker Base Images for WordPress

This repo builds base Docker base images for WordPress.

## Build Arguments

The following variables can be only be configured at build.

| Build Arg           | Description                                                                                                                                    |
|---------------------|------------------------------------------------------------------------------------------------------------------------------------------------|
| `WORDPRESS_VERSION` | WordPress version                                                                                                                              |
| `PHP_VERSION`       | PHP version                                                                                                                                    |
| `PHP_EXTENSIONS`    | Additional extensions to install (using [`mlocati/docker-php-extension-installer`](https://github.com/mlocati/docker-php-extension-installer)) |
| `FLAVOR`            | Base image type. One of `apache`,  `fpm-alpine`, or `cli`                                                                                      |

## Runtime Configuration

### PHP Configuration

The following variables can be configured at build (Typically with an `ARG` in the `Dockerfile`) or during runtime (With environment variables).

| Build Arg                 | Description                                                                                              | Default |
|---------------------------|----------------------------------------------------------------------------------------------------------|---------|
| `PHP_MAX_EXECUTION_TIME`  | See [`max_execution_time`](https://www.php.net/manual/en/info.configuration.php#ini.max-execution-time). | `30`    |
| `PHP_MAX_INPUT_VARS`      | See [`max_input_vars`](https://www.php.net/manual/en/info.configuration.php#ini.max-input-vars).         | `1000`  |
| `PHP_MEMORY_LIMIT`        | See [`memory_limit`](https://www.php.net/manual/en/ini.core.php#ini.memory-limit).                       | `256M`  |
| `PHP_POST_MAX_SIZE`       | See [`post_max_size`](https://www.php.net/manual/en/ini.core.php#ini.post-max-size).                     | `32M`   |
| `PHP_UPLOAD_MAX_FILESIZE` | See [`upload_max_filesize`](https://www.php.net/manual/en/ini.core.php#ini.upload-max-filesize).         | `8M`    |
| `PHP_MAX_FILE_UPLOADS`    | See [`max_file_uploads`](https://www.php.net/manual/en/ini.core.php#ini.max-file-uploads).               | `20`    |
