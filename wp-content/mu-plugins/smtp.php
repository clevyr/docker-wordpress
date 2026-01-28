<?php

if (!defined('ABSPATH')) {
  exit;
}

add_action('phpmailer_init', 'phpmailer_envconfig');

function phpmailer_envconfig($phpmailer) {
  $mailer = getenv_docker('MAIL_MAILER', '');

  if ($mailer === 'smtp') {
    $phpmailer->isSMTP();
    $phpmailer->Host       = getenv_docker('MAIL_HOST', '');
    $phpmailer->Port       = getenv_docker('MAIL_PORT', 587);
    $phpmailer->SMTPSecure = getenv_docker('MAIL_SMTP_SECURE', 'tls');
    $phpmailer->SMTPAuth   = getenv_docker('MAIL_SMTP_AUTH', true);
    $phpmailer->Username   = getenv_docker('MAIL_USERNAME', '');
    $phpmailer->Password   = getenv_docker('MAIL_PASSWORD', '');

    $from = getenv_docker('MAIL_FROM_ADDRESS', '');
    if ($from) {
      $phpmailer->From = $from;
    }

    $fromName = getenv_docker('MAIL_FROM_NAME', '');
    if ($fromName) {
      $phpmailer->FromName = getenv_docker('MAIL_FROM_NAME', '');
    }
  }
}

add_action('wp_mail_failed', 'phpmailer_error_log');

function phpmailer_error_log($wp_error) {
  if (WP_DEBUG) {
    error_log('Mail failed: ' . $wp_error->get_error_message());
  }
};
