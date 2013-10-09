class collectd::server inherits collectd {
  package { 'rrdtool':
    ensure => installed,
  }

  File['/etc/collectd.d/network.conf'] {
    ensure  => file,
    mode    => '0644',
    source  => 'puppet:///modules/collectd/collectd.d/network.conf-server',
    require => [ Package['collectd'], Package['rrdtool'] File['/etc/collectd.d'] ],
    notify  => Service['collectd'],
  }

  file { '/etc/collectd.d/rrdtool.conf':
    ensure  => file,
    mode    => '0644',
    source  => 'puppet:///modules/collectd/collectd.d/rrdtool.conf',
    require => [ Package['collectd'], File['/etc/collectd.d'] ],
    notify  => Service['collectd'],
  }
}
