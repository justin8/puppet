class monitoring {
  case $operatingsystem {
    'Archlinux': {
      $config_location = '/etc/telegraf/telegraf.conf'
      ensure_packages(['telegraf'])
    }
    'Ubuntu': {
      $config_location = '/etc/opt/telegraf/telegraf.conf'
      $package_source_name = "telegraf_0.1.9_amd64.deb"
      $package_source = "https://s3.amazonaws.com/get.influxdb.org/telegraf/${package_source_name}"
      wget::fetch { 'telegraf':
        source      => $package_source,
        destination => "/tmp/${package_source_name}"
      }
      package { 'telegraf':
        ensure   => $my_package_ensure,
        provider => 'dpkg',
        source   => "/tmp/${package_source_name}",
        require  => Wget::Fetch['telegraf'],
      }
    }
    default: {
      fail('Unsupported OS')
    }
  }

  file { $config_location:
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
      File[$config_location],
      Exec['systemd-daemon-reload'],
    ];
  }
}
