class os_default::cron {
  case $::operatingsystem {
    'Archlinux': { $cron_package = 'cronie'}
    default: { $cron_package = 'cron' }
  }
  package { $cron_package: ensure => installed }

  service { $cron_package:
    ensure    => running,
    enable    => true,
    require   => Package[$cron_package],
  }
}
