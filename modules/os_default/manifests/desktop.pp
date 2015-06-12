class os_default::desktop {
  include os_default::cron

  ensure_packages('preload', 'prelink')

  file { '/etc/cron.daily/prelink.cron':
    ensure => absent,
  }

  cron { 'prelink':
    command  => 'prelink -amR',
    minute   => '0',
    hour     => '4',
    month    => '*',
    weekday  => '*',
    monthday => '*',
    require  => Package['prelink', $::os_default::cron::cron_package],
  }

  service {
    'preload':
      ensure  => running,
      enable  => true,
      require => Package['preload'];
  }

  if $networkmanager == 'true' {
    package {
      'networkmanager-dispatcher-ntpd':
        ensure   => installed,
        require => Package['ntp'];
    }

    service { 'NetworkManager-dispatcher':
      ensure    => running,
      enable => true;
    }
  }

}
