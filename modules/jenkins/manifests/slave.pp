class jenkins::slave {

  $packages = [ 'jre7-openjdk-headless', 'abs', 'git' ]
  package { $packages: ensure => installed }

  user {
    'jenkins':
      home   => '/var/lib/jenkins',
      system => true;
  }

  file {
    '/etc/sudoers.d/jenkins':
      ensure  => file,
      source  => 'puppet:///modules/jenkins/sudoers.d-jenkins';

    '/var/lib/jenkins/.ssh':
      ensure => directory,
      mode   => '0700',
      owner  => 'jenkins',
      group  => 'jenkins',
      require => User['jenkins'];

    '/var/lib/jenkins/.ssh/authorized_keys':
      ensure => file,
      mode   => '0600',
      owner  => 'jenkins',
      group  => 'jenkins',
      source => 'puppet:///modules/jenkins/authorized_keys',
      require => File['/var/lib/jenkins/.ssh'];
  }
}
