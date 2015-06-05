class monitoring {
  class { 'diamond':
    graphite_host    => 'abachi.local',
    interval         => 10,
    purge_handlers   => true,
    purge_collectors => true,
  }

  package { ['python2-yaml']: ensure => installed }

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
