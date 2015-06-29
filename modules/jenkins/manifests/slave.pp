class jenkins::slave {

  ensure_packages(['jre8-openjdk-headless', 'abs', 'devtools'])

  user {
    'jenkins':
      home   => '/var/lib/jenkins',
      groups => ['docker'],
      system => true;
  }

  cron { 'abs':
    command  => 'abs',
    minute   => '0',
    hour     => '1',
    month    => '*',
    weekday  => '*',
    monthday => '*',
  }

  file {
    '/usr/local/bin/dmakepkg':
      mode   => '0755',
      source => 'puppet:///modules/jenkins/dmakepkg';

    '/etc/makepkg.conf':
      source => 'puppet:///modules/jenkins/makepkg.conf';

    '/var/lib/jenkins':
      ensure => directory,
      owner  => 'jenkins',
      group  => 'jenkins';

    '/var/lib/jenkins/.ssh':
      ensure  => directory,
      mode    => '0700',
      owner   => 'jenkins',
      group   => 'jenkins',
      require => User['jenkins'];

    '/var/lib/jenkins/.ssh/authorized_keys':
      mode    => '0600',
      owner   => 'jenkins',
      group   => 'jenkins',
      source  => 'puppet:///modules/jenkins/authorized_keys',
      require => File['/var/lib/jenkins/.ssh'];
  }
}
