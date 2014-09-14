class btsync( $webui = 'local' ) {

  package { 'btsync':
    ensure => present,
  }

  service { 'btsync':
    ensure => running,
    enable => true,
    require => Package['btsync'],
  }

  file { '/etc/btsync.conf':
    owner   => 'btsync',
    group   => 'btsync',
    mode    => '0600',
    require => Package['btsync'],
    notify  => Service['btsync'],
    content => template('btsync/btsync.conf.erb'),
  }

  file { '/var/lib/btsync/sync':
    ensure  => directory,
    owner   => 'btsync',
    group   => 'btsync',
    mode    => '2775',
    require => Package['btsync'],
  }

  cron { 'btsync perms':
    command  => '/usr/bin/chmod -R g+w /var/lib/btsync/sync',
    minute   => '*',
    hour     => '*',
    month    => '*',
    monthday => '*',
    weekday  => '*',
  }

  exec { 'sync permissions':
    command => 'setfacl -d -m g::rwx /var/lib/btsync/sync',
    unless  => 'getfacl /var/lib/btsync/sync | grep default',
  }

}
