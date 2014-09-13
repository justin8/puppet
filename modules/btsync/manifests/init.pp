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

}
