class monitoring {
  #if $operatingsystem != 'Archlinux' {
  #  $install_from_pip = true
  #} else {
  #  $install_from_pip = false
  #}

  #class { 'diamond':
  #  graphite_host    => 'abachi.local',
  #  interval         => 10,
  #  purge_handlers   => true,
  #  purge_collectors => true,
  #  install_from_pip  => $install_from_pip
  #}

  # Change to telegraf module in the future
  case $operatingsystem {
    'Archlinux': {
      ensure_packages(['telegraf'])
    }
    'Ubuntu': {
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

  file {
    '/etc/telegraf':
      ensure => directory;

    '/etc/telegraf/telegraf.conf':
      ensure  => present,
      mode    => '0644',
      content => template('monitoring/telegraf.conf.erb'),
      require => Package['telegraf'];
  }

  file {
    '/etc/systemd/system/telegraf.service.d':
      ensure => directory;

    '/etc/systemd/system/telegraf.service.d/config.conf':
      ensure => present,
      source => 'puppet:///modules/monitoring/systemd-service.conf',
      notify => Exec['systemd-daemon-reload'];
  }

  service { 'telegraf':
    ensure  => running,
    enable  => true,
    require => [
      Package['telegraf'],
      File['/etc/systemd/system/telegraf.service.d/config.conf'],
      Exec['systemd-daemon-reload'],
    ];
  }

  #diamond::collector {
  #  ['CPUCollector',
  #   'DiskSpaceCollector',
  #   'DiskUsageCollector',
  #   'MemoryCollector',
  #   'VMStatCollector',
  #   'LoadAverageCollector',
  #   'PuppetAgentCollector']: ;

  # 'NetworkCollector':
  #   options => {'interfaces' => 'eth, bond, ens, enx, enp, eno'};
  #}



  # Service-based auto-collection
  #if $is_virtual == 'false' {
  #  package { 'python2-pysensors': ensure => installed }
  #  diamond::collector { 'LMSensorsCollector': }
  #}

}
