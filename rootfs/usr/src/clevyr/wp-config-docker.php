<?php

if (!function_exists('define_docker_env')) {
    function define_docker_env($name, $default = null) {
        $value = getenv_docker($name, $default);
        if ($value !== null) {
            define($name, $value);
        }
    }
}

define_docker_env('DISABLE_WP_CRON', true);

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
