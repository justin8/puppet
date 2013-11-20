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

    '/usr/local/bin/update_puppet':
      ensure => file,
      mode   => '0775',
      source => 'puppet:///modules/puppetmaster/update_puppet';

    '/etc/puppet/autosign.conf':
      ensure => file,
      source => 'puppet:///modules/puppetmaster/autosign.conf';
  }

  exec { "update_puppet": command => '/usr/local/bin/update_puppet' }
}
