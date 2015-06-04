class monitoring {
  if $operatingsystem == "Fedora" { $pip = true } else { $pip = false }

  class { 'diamond':
    graphite_host    => 'abachi.local',
    interval         => 10,
    purge_handlers   => true,
    purge_collectors => true,
    install_from_pip => $pip
  }

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
