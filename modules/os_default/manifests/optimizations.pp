class os_default::optimizations {
  $packages = [ 'prelink', 'preload' ]
  package { $packages: ensure => installed }


  file { 'prelink.cron':
    path    => '/etc/cron.daily/prelink.cron',
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0775',
    require => Package['prelink', 'cronie'],
    source  => 'puppet:///modules/os_default/prelink.cron',
  }

  service { 'preload':
    ensure  => running,
    enable  => true,
    require => Package['preload'],
  }
}
