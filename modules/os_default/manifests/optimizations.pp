class optimizations {
  package { 'prelink':
    ensure => installed,
  }
  file { 'prelink.cron':
    path    => '/etc/cron.daily/prelink',
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0664',
    require => Package['prelink', 'cron'],
    source  => 'puppet:///modules/os_default/prelink.cron',
  }

  package { 'preload':
    ensure => installed,
  }
  service { 'preload':
    name      => preload,
    ensure    => running,
    enable    => true,
  }
}
