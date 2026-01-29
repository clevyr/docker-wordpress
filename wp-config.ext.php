/* C3 Cloudfront Clear Cache envs */
define('AWS_ACCESS_KEY_ID', getenv_docker('AWS_ACCESS_KEY_ID', null));
define('AWS_SECRET_ACCESS_KEY', getenv_docker('AWS_SECRET_ACCESS_KEY', null));
define('C3_DISTRIBUTION_ID', getenv_docker('C3_DISTRIBUTION_ID', null));
define('C3_DISTRIBUTION_TENANT_ID', getenv_docker('C3_DISTRIBUTION_TENANT_ID', null));
