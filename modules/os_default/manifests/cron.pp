class os_default::cron {
  case $::operatingsystem {
    'Archlinux': {
      $cron_package = 'cronie'
      $cron_service = 'cronie'
    }
    'Fedora': {
      $cron_package = 'cronie'
      $cron_service = 'crond'
    }
    'Ubuntu': {
      $cron_package = 'cron'
      $cron_service = 'cron'
    }
    default: {
      $cron_package = 'cron'
      $cron_service = 'crond'
    }
  }
  ensure_packages([$cron_package])

  service { $cron_service:
    ensure    => running,
    enable    => true,
    require   => Package[$cron_package],
  }
}
