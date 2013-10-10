class collectd::physical inherits collectd {

  file { '/etc/collectd.d/physical.conf':
    ensure  => file,
    source  => 'puppet:///modules/collectd/collectd.d/physical.conf',
    mode    => '0644',
    require => [ Package['collectd'], File['/etc/collectd.d'] ],
    notify  => Service['collectd'],
  }

}
