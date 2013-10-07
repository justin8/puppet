class collectd {

  package { 'collectd':
    ensure => installed,
  }

  service { 'collectd':
    ensure    => running,
    enable    => true,
  }

  file { '/etc/collectd.conf':
    ensure  => file,
    source  => 'puppet:///modules/collectd/collectd.conf',
    require => Package['collectd'],
    notify  => Service['collectd'],
  }

  file { '/etc/collectd.d':
    ensure  => directory,
  }

  @file { '/etc/collectd.d/network.conf':
    ensure  => file,
    mode    => '0644',
    source  => 'puppet:///modules/collectd/collectd.d/network.conf-client'),
    require => [ Package['collectd'], File['/etc/collectd.d'] ],
    notify  => Service['collectd'],
  }

  realize(File['/etc/collectd.d/network.conf'])

}
