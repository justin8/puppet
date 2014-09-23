class desktop {

  $packages = [ 'preload', 'prelink', 'profile-sync-daemon' ]
  package { $packages: ensure => installed }

  #psd.conf config
  file { '/etc/psd.conf':
    content => template ('os_default/psd.conf.erb'),
  }

  service { 'profile-sync-daemon':
    ensure => running,
    enable => true,
  }

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
    require  => Package['prelink', 'cronie'],
  }

  service {
    'preload':
      ensure  => running,
      enable  => true,
      require => Package['preload'];
  }

}
