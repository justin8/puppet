class optimizations {
  package { 'prelink': ensure => installed }

  file { 'prelink.cron':
    path    => '/etc/cron.daily/prelink.cron',
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0775',
    require => Package['prelink', 'cronie'],
    source  => 'puppet:///modules/os_default/prelink.cron',
  }

  package { 'preload': ensure => installed }

  service { 'preload':
    ensure    => running,
    enable    => true,
  }
}
