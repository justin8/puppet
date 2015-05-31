class monitoring::physical {
  include monitoring
  $packages = [ 'hddtemp', 'lm_sensors' ]

  if $::virtual == 'physical' {
    package { $packages: ensure => installed }

    service { 'hddtemp':
      ensure  => running,
      enable  => true,
      require => Package['hddtemp'],
      notify  => Service['collectd'],
    }

    file { '/etc/collectd.d/physical.conf':
      ensure  => file,
      source  => 'puppet:///modules/monitoring/collectd.d/physical.conf',
      mode    => '0644',
      require => [ Package['collectd'], File['/etc/collectd.d'] ],
      notify  => Service['collectd'],
    }

    file {
      '/etc/systemd/system/hddtemp.service.d':
        ensure => directory;

      '/etc/systemd/system/hddtemp.service.d/disks.conf':
        ensure  => present,
        content => template('monitoring/hddtemp-disks.conf.erb'),
        notify  => [ Exec['systemd-daemon-reload'], Service['hddtemp'] ];
    }
  } else {
    package { $packages: ensure => absent }

    service { 'hddtemp':
      ensure => stopped,
      enable => false,
      before => Package['hddtemp']
    }

    file { ['/etc/systemd/system/hddtemp.service.d',
            '/etc/collectd.d/physical.conf']:
      ensure  => absent,
      recurse => true,
      force   => true,
    }
  }

}
