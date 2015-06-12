class os_default::cron {
  case $::operatingsystem {
    'Archlinux': { $cron_package = 'cronie'}
    default: { $cron_package = 'cron' }
  }
  ensure_packages($cron_package)

  service { $cron_package:
    ensure    => running,
    enable    => true,
    require   => Package[$cron_package],
  }
}
