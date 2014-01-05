class puppetmaster {
  package { 'puppet': ensure => installed }

  service { 'puppetmaster':
    ensure => running,
    enable => true,
  }

  file { 
    '/etc/cron.d/puppet.cron':
      ensure => file,
      mode   => '0664',
      source => 'puppet:///modules/puppetmaster/puppet.cron';

    '/usr/local/bin/update-puppet':
      ensure => file,
      mode   => '0775',
      source => 'puppet:///modules/puppetmaster/update-puppet';

    '/etc/puppet/autosign.conf':
      ensure => file,
      source => 'puppet:///modules/puppetmaster/autosign.conf';
  }
}
