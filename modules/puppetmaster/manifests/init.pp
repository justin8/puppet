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
    source => 'puppet:///modules/puppetmaster/puppet.cron',
  }

  vcsrepo { '/etc/puppet':
    ensure => latest,
    provider => git,
    source => 'git://github.com/justin8/puppet',
    revision => 'master'
  }
}
