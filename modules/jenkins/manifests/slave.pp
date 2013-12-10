class jenkins::slave {
  class { 'repo::mount': user => 'jenkins'; }

  $packages = [ 'jre7-openjdk-headless', 'abs', 'git' ]
  package { $packages: ensure => installed }

  user {
    'jenkins':
      home   => '/var/lib/jenkins',
      system => true;
  }

  exec {
    '/usr/local/bin/update-sources':
      path    => '/usr/bin',
      unless  => 'test -d /var/lib/jenkins/aur-mirror',
      require => File['/usr/local/bin/update-sources'],
      timeout => 0;
  }

  file {
    '/etc/sudoers.d/jenkins':
      ensure  => file,
      source  => 'puppet:///modules/jenkins/sudoers.d-jenkins';

    '/usr/local/bin/update-sources':
      ensure  => file,
      source  => 'puppet:///modules/jenkins/update-sources';

    '/etc/cron.d/update-sources.cron':
      ensure  => file,
      source  => 'puppet:///modules/jenkins/cron.d-update-sources';

    '/var/lib/jenkins':
      ensure  => directory,
      owner   => 'jenkins',
      group   => 'jenkins';

    '/var/lib/jenkins/.ssh':
      ensure  => directory,
      mode    => '0700',
      owner   => 'jenkins',
      group   => 'jenkins',
      require => User['jenkins'];

    '/var/lib/jenkins/.ssh/authorized_keys':
      ensure  => file,
      mode    => '0600',
      owner   => 'jenkins',
      group   => 'jenkins',
      source  => 'puppet:///modules/jenkins/authorized_keys',
      require => File['/var/lib/jenkins/.ssh'];
  }
}
