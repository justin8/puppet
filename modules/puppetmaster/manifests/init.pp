class puppetmaster {
  package {
    'puppet3':
      ensure => installed;

    [ 'hiera-eyaml',
      'highline',
      'trollop']:
      ensure   => installed,
      provider => 'gem';
  }

  service { 'puppetmaster':
    ensure => running,
    enable => true,
  }

  vcsrepo { '/etc/hieradata':
    ensure   => latest,
    source   => 'git@github.com:justin8/hieradata.git',
    revision => 'master',
  }

  file {
    '/usr/local/sbin/update-puppet':
      ensure => file,
      mode   => '0775',
      source => 'puppet:///modules/puppetmaster/update-puppet';

    '/etc/puppet/autosign.conf':
      ensure => file,
      source => 'puppet:///modules/puppetmaster/autosign.conf';

    '/etc/puppet/keys':
      recurse => true,
      owner   => 'puppet',
      group   => 'puppet',
      mode    => '0400';
  }

}
