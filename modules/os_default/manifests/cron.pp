class cron {
  package { 'cronie':
    ensure => installed,
  }
  service { 'cronie':
    name      => cronie,
    ensure    => running,
    enable    => true,
  }
}
