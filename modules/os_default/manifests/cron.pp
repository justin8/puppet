class os_default::cron {
  package { 'cronie': ensure => installed }

  service { 'cronie':
    ensure    => running,
    enable    => true,
  }
}
