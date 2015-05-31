class monitoring {
  include monitoring::physical

  package { 'collectd':
    ensure => installed,
  }

  service { 'collectd':
    ensure    => running,
    enable    => true,
  }

  file { '/etc/collectd.conf':
    ensure  => file,
    source  => 'puppet:///modules/monitoring/collectd.conf',
    require => Package['collectd'],
    notify  => Service['collectd'],
  }

  file { '/etc/collectd.d':
    ensure  => directory,
  }

  file { ['/etc/collectd.d/network.conf',
          '/etc/collectd.d/rrdtool.conf',
          '/etc/collectd.d/passwd']:
    ensure => absent,
  }

  if $zfs_version {
    file { '/etc/collectd.d/zfs.conf':
      ensure => file,
      source => 'puppet:///modules/monitoring/collectd.d/zfs.conf',
      require => [ Package['collectd'], File['/etc/collectd.d'] ],
      notify  => Service['collectd'],
    }
  }

  if $::networkmanager == 'true' {
    file { '/etc/NetworkManager/dispatcher.d/10-collectd':
      mode   => '0755',
      source => 'puppet:///modules/monitoring/nm-dispatcher-collectd',
    }
  }
}
