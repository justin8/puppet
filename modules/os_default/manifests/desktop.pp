class desktop {

  $packages = [ 'profile-sync-daemon' ]
  package { $packages: ensure => installed }

  #psd.conf config
  file { '/etc/psd.conf':
    content => template ('os_default/psd.conf.erb'),
  }

  service { 'profile-sync-daemon':
    ensure => running,
    enable => true,
  }

}
