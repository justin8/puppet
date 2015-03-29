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

  if $zfs_version {
    file { '/etc/collectd.d/zfs.conf':
      ensure => file,
      source => 'puppet:///modules/collectd/collectd.d/zfs.conf',
      require => [ Package['collectd'], File['/etc/collectd.d'] ],
      notify  => Service['collectd'],
    }
  }

  file { '/etc/collectd.d/network.conf':
    ensure  => file,
    source  => 'puppet:///modules/collectd/collectd.d/network.conf-client',
    require => [ Package['collectd'], File['/etc/collectd.d'] ],
    notify  => Service['collectd'],
  }

  if $::networkmanager {
    file { '/etc/networkmanager/dispatcher.d/10-collectd':
      mode   => '0755',
      source => 'puppet:///modules/collectd/nm-dispatcher-collectd',
    }
  } else {
    file { '/etc/networkmanager/dispatcher.d/10-collectd':
      ensure => absent,
    }
  }
}
