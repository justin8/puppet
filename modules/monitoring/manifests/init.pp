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

  case $operatingsystem {
    'Archlinux': {
      ensure_packages(['python2-yaml'])
    }
    'Ubuntu': {
      ensure_packages(['python-yaml'])
    }
    default: {
      fail('Unsupported OS')
    }
  }

  diamond::collector {
    ['CPUCollector',
     'DiskSpaceCollector',
     'DiskUsageCollector',
     'MemoryCollector',
     'VMStatCollector',
     'LoadAverageCollector',
     'NtpdCollector';

   'NetworkCollector':
     options => {'interfaces' => 'eth, bond, ens, enx, enp, eno'};
  }



  # Service-based auto-collection
  if $is_virtual == 'false' {
    package { 'python2-pysensors': ensure => installed }
    diamond::collector { 'LMSensorsCollector': }
  }

}
