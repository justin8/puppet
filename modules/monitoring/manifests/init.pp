class monitoring inherits monitoring::params{
  ensure_packages(['telegraf'])

  file { $telegraf_config:
    ensure  => present,
    mode    => '0644',
    content => template('monitoring/telegraf.conf.erb'),
    require => Package['telegraf'];
  }

  service { 'telegraf':
    ensure  => running,
    enable  => true,
    require => [
      Package['telegraf'],
      File[$telegraf_config],
      Exec['systemd-daemon-reload'],
    ];
  }
}
