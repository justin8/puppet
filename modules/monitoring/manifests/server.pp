class monitoring::server inherits monitoring::params {
  include systemd
  include monitoring

  vhost { 'grafana':
    url      => 'grafana.dray.be',
    upstream => 'localhost:3000',
  }

  ensure_packages(['grafana', 'influxdb'])

  file {
    '/etc/systemd/system/influxdb.service':
      content => template('monitoring/influxdb.service.erb'),
      notify  => Exec['systemd-daemon-reload'],
      require => Package['influxdb'];

    '/etc/systemd/system/grafana.service':
      content => template('monitoring/grafana.service.erb'),
      notify  => Exec['systemd-daemon-reload'],
      require => Package['grafana'];
  }

  service {
    'influxdb':
      ensure => running,
      enable => true,
      require => File['/etc/systemd/system/influxdb.service'];

    'grafana':
      ensure => running,
      enable => true,
      require => File['/etc/systemd/system/grafana.service'];
  }

  file { $grafana_config:
    ensure  => file,
    mode    => '0644',
    source  => 'puppet:///modules/monitoring/grafana.ini',
    require => Package['grafana'],
    notify  => Service['grafana']
  }

  file { $influxdb_config:
    ensure  => file,
    mode    => '0644',
    source  => 'puppet:///modules/monitoring/influxdb.conf',
    require => Package['influxdb'],
    notify  => Service['influxdb']
  }

}
