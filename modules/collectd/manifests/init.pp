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

  file { '/etc/collectd.d/network.conf':
    ensure  => file,
    mode    => '0644',
    content  => template('puppet:///modules/collectd/network.erb'),
    require => Package['collectd'],
    notify  => Service['collectd'],
  }
}
