class os_default::desktop {

  $packages = [ 'preload', 'prelink' ]
  package { $packages: ensure => installed }


# CAN BE REMOVED LATER

  package { 'profile-sync-daemon': ensure => absent }

  #psd.conf config
  file {
    '/etc/psd.conf':
      ensure => absent;

    '/etc/systemd/system/psd-resync.timer.d':
      ensure => absent;

    '/etc/systemd/system/psd-resync.timer.d/frequency.conf':
      ensure => absent;

    '/etc/modules-load.d/overlay.conf':
      ensure => absent;
  }

  service { 'psd':
    ensure => stopped,
    enable => false,
  }

####### DO NOT REMOVE PAST HERE

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
