<?php

if (!defined('ABSPATH')) {
  exit;
}

/**
 * Forces the "Search engine visibility" setting (the `blog_public` option).
 */
add_filter('pre_option_blog_public', 'blog_public_envconfig');
add_filter('pre_update_option_blog_public', 'blog_public_lock_update', 10, 2);
add_action('admin_footer-options-reading.php', 'blog_public_lock_field');

function blog_public_forced() {
  $override = getenv_docker('WP_BLOG_PUBLIC', '');
  if ($override === '') {
    return null;
  }

  return filter_var($override, FILTER_VALIDATE_BOOLEAN) ? '1' : '0';
}

function blog_public_envconfig($value) {
  $forced = blog_public_forced();
  return $forced === null ? $value : $forced;
}

function blog_public_lock_update($value, $old_value) {
  $forced = blog_public_forced();
  return $forced === null ? $value : $old_value;
}

function blog_public_lock_field() {
  if (blog_public_forced() === null) {
    return;
  }

  ?>
  <script>
    (function () {
      var fieldset = document.querySelector('.option-site-visibility fieldset');
      if (!fieldset) {
        return;
      }

      fieldset.querySelectorAll('input[name="blog_public"]').forEach(function (input) {
        input.disabled = true;
      });

      var note = document.createElement('p');
      note.className = 'description';
      note.textContent = 'This setting is managed by the hosting environment and cannot be changed here.';
      fieldset.appendChild(note);
    })();
  </script>
  <?php
}
