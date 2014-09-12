class btsync($webui=remote) {

  package { 'btsync':
    ensure => present,
  }

  service { 'btsync':
    ensure => running,
    enable => true,
    require => Package['btsync'],
  }

  file { '/etc/btsync.conf':
    owner => 'btsync',
    group => 'btsync',
    mode  => '0600',
    require => Package['btsync'],
  }

}
