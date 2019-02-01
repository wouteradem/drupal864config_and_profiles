<?php

/**
 * @file
 * Allows to install the installation profile from base configuration.
 */

/**
 * Implements hook_install_tasks_alter().
 */
function wouter_install_tasks_alter(&$tasks, $install_state) {
  if (!$install_state['installation_finished']) {
    _alter_profile($install_state['parameters']['profile']);
  }
  $tasks += ['wouter_install_finished' => []];
}

function wouter_install_finished() {
  _alter_profile('standard');
}

function _alter_profile($profile_name) {
  $sync_directory = DRUPAL_ROOT . '/files-private/config/default';
  $file_storage = new \Drupal\Core\Config\FileStorage($sync_directory);
  $core_extension = $file_storage->read('core.extension');
  if (isset($core_extension['profile'])) {
    $core_extension['profile'] = $profile_name;
    if ($profile_name != 'standard') {
      $core_extension['module'][$profile_name] = 1000;
    }
    else {
      unset($core_extension['module'][\Drupal::installProfile()]);
    }
    $file_storage->write('core.extension', $core_extension);
  }
}
