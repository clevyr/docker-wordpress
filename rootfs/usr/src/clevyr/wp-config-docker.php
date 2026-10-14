<?php

if (!function_exists('define_docker_env')) {
    function define_docker_env($name, $default = null) {
        $value = getenv_docker($name, $default);
        if ($value !== null) {
            define($name, $value);
        }
    }
}

if (!function_exists('define_docker_env_bool')) {
    /**
     * Defines a boolean constant from an env var. Unlike define_docker_env,
     * "false" and "0" define false instead of a truthy string. Unset or
     * empty falls back to $default, and a null default leaves it undefined.
     */
    function define_docker_env_bool($name, $default = null) {
        $value = getenv_docker($name, '');
        if ($value !== '') {
            define($name, filter_var($value, FILTER_VALIDATE_BOOLEAN));
        } elseif ($default !== null) {
            define($name, $default);
        }
    }
}

define_docker_env('DISABLE_WP_CRON', true);

/* File modification lockdown */
define_docker_env_bool('DISALLOW_FILE_EDIT', true);
define_docker_env_bool('DISALLOW_FILE_MODS');

/* Page cache plugins (advanced-cache.php) */
define_docker_env_bool('WP_CACHE');

/* C3 Cloudfront Clear Cache envs */
define_docker_env('AWS_ACCESS_KEY_ID');
define_docker_env('AWS_SECRET_ACCESS_KEY');
define_docker_env('C3_DISTRIBUTION_ID');
define_docker_env('C3_DISTRIBUTION_TENANT_ID');

/* rhubarbgroup/redis-cache envs */
define_docker_env('WP_REDIS_HOST');
define_docker_env('WP_REDIS_PORT');
define_docker_env('WP_REDIS_PASSWORD');
define_docker_env('WP_REDIS_DATABASE');
define_docker_env('WP_REDIS_PREFIX');
define_docker_env('WP_REDIS_MAXTTL');
