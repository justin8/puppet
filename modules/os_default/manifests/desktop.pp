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

  file { 'prelink.cron':
    ensure  => file,
    path    => '/etc/cron.daily/prelink.cron',
    owner   => 'root',
    group   => 'root',
    mode    => '0775',
    require => Package['prelink', 'cronie'],
    source  => 'puppet:///modules/os_default/prelink.cron',
  }

  service {
    'preload':
      ensure  => running,
      enable  => true,
      require => Package['preload'];
  }

}
