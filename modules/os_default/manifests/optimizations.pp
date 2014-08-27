class os_default::optimizations {
  $packages = [ 'prelink', 'preload' ]
  package { $packages: ensure => installed }


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

    'nscd':
      ensure  => running,
      enable  => true,
  }
}
