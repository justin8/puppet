class puppetmaster {
  package { 'puppet': ensure => installed }

  service { 'puppetmaster':
    ensure => running,
    enable => true,
  }

  file {
    '/usr/local/bin/update-puppet':
      ensure => file,
      mode   => '0775',
      source => 'puppet:///modules/puppetmaster/update-puppet';

    '/etc/puppet/autosign.conf':
      ensure => file,
      source => 'puppet:///modules/puppetmaster/autosign.conf';
  }

  cron { 'update-puppet':
    user     => 'root',
    minute   => '*/5',
    hour     => '*',
    month    => '*',
    monthday => '*',
    weekday  => '*',
  }

}
