class os_default::desktop {
  include os_default::cron

  $packages = [ 'preload', 'prelink' ]
  package { $packages: ensure => installed }

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

}
