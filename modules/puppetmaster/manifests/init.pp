class puppetmaster {
  package { 'puppet':
    ensure => installed,
  }

  service { 'puppetmaster':
    ensure => running,
    enable => true,
  }

  file { 'puppet.cron':
    path   => '/etc/cron.d/puppet.cron',
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0664',
    source => 'puppet:///modules/puppetmaster/puppet.cron',
  }

  file { 'update_puppet':
    path   => '/usr/local/bin/update_puppet',
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0775',
    source => 'puppet:///modules/puppetmaster/update_puppet',
  }

  exec { "update_puppet":
    command => '/usr/local/bin/update_puppet',
  }
}
