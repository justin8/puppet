class monitoring::server {
  include monitoring

  vhost { 'grafana':
    url      => 'grafana.dray.be',
    upstream => 'localhost:3000',
  }

  ensure_packages(['grafana', 'influxdb'])

    service {
      'influxdb':
        ensure => running,
        enable => true,
        require => Package['influxdb'];
  
      'grafana':
        ensure => running,
        enable => true,
        require => Package['grafana'];
    }

  file { '/etc/grafana/grafana.ini':
    ensure  => file,
    mode    => '0644',
    source  => 'puppet:///modules/monitoring/grafana.ini',
    require => Package['grafana'],
    notify  => Service['grafana']
  }

  file { '/etc/influxdb.conf':
    ensure  => file,
    mode    => '0644',
    source  => 'puppet:///modules/monitoring/influxdb.conf',
    require => Package['influxdb'],
    notify  => Service['influxdb']
  }

}
