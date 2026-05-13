define('DISABLE_WP_CRON', getenv_docker('DISABLE_WP_CRON', true));

/* C3 Cloudfront Clear Cache envs */
define('AWS_ACCESS_KEY_ID', getenv_docker('AWS_ACCESS_KEY_ID', null));
define('AWS_SECRET_ACCESS_KEY', getenv_docker('AWS_SECRET_ACCESS_KEY', null));
define('C3_DISTRIBUTION_ID', getenv_docker('C3_DISTRIBUTION_ID', null));
define('C3_DISTRIBUTION_TENANT_ID', getenv_docker('C3_DISTRIBUTION_TENANT_ID', null));

/* rhubarbgroup/redis-cache envs */
define('WP_REDIS_HOST', getenv_docker('WP_REDIS_HOST', null));
define('WP_REDIS_PORT', getenv_docker('WP_REDIS_PORT', 6379));
define('WP_REDIS_PASSWORD', getenv_docker('WP_REDIS_PASSWORD', null));
define('WP_REDIS_DATABASE', getenv_docker('WP_REDIS_DATABASE', 0));
define('WP_REDIS_PREFIX', getenv_docker('WP_REDIS_PREFIX', null));
define('WP_REDIS_MAXTTL', getenv_docker('WP_REDIS_MAXTTL', 0));
