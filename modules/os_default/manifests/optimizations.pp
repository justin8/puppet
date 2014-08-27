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

  # Fix for slow drives causing hangs
  # See: http://lwn.net/Articles/572911/
  sysctl {
    'vm.dirty_background_bytes': value => '16777216';
    'vm.dirty_bytes': value => '50331648';
    # Prioritize inode/dentry cache over block cache
    'vm.vfs_cache_pressure': value => '50';
  }

}
