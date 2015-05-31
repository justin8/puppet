class monitoring::physical {
  include monitoring

  file { '/etc/collectd.d/physical.conf':
    ensure  => file,
    source  => 'puppet:///modules/monitoring/collectd.d/physical.conf',
    mode    => '0644',
    require => [ Package['collectd'], File['/etc/collectd.d'] ],
    notify  => Service['collectd'],
  }

  $packages = [ 'hddtemp', 'lm_sensors' ]
  package { $packages: ensure => installed }

  service { 'hddtemp':
    ensure  => running,
    enable  => true,
    require => Package['hddtemp'],
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

}
