class puppetmaster {
  service { 'puppetmaster':
    ensure => running,
    enable => true,
  }

  file { 'puppet.cron':
    path   => '/etc/cron.d/puppet.cron',
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0775',
    source => 'puppet:///modules/os_default/puppet.cron',
  }
}
