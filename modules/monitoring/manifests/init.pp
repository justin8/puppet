class monitoring {
  if $operatingsystem != 'Archlinux' {
    $install_from_pip = true
  } else {
    $install_from_pip = false
  }

  class { 'diamond':
    graphite_host    => 'abachi.local',
    interval         => 10,
    purge_handlers   => true,
    purge_collectors => true,
    install_from_pip  => $install_from_pip
  }

  ensure_packages(['python2-yaml'])

  service { 'collectd':
    ensure => stopped,
    enable => false,
  }

  package { ['collectd', 'hddtemp']:
    ensure => absent,
    require => Service['collectd']
  }

  diamond::collector { ['CPUCollector',
                        'DiskSpaceCollector',
                        'DiskUsageCollector',
                        'MemoryCollector',
                        'VMStatCollector',
                        'NetworkCollector',
                        'LoadAverageCollector',
                        'NtpdCollector',
                        'PuppetAgentCollector']: }

  # Service-based auto-collection
  if $is_virtual == 'false' {
    package { 'python2-pysensors': ensure => installed }
    diamond::collector { 'LMSensorsCollector': }
  }

}
