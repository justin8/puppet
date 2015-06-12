class jenkins::slave {

  ensure_packages(['jre8-openjdk-headless', 'abs', 'devtools'])

  user {
    'jenkins':
      home   => '/var/lib/jenkins',
      groups => ['docker'],
      system => true;
  }

  file {
    #'/usr/local/bin/makechrootpkg-jenkins':
    # ensure  => absent,
    # source  => 'puppet:///modules/jenkins/makechrootpkg-jenkins';

    '/usr/local/bin/dmakepkg':
      mode   => '0755',
      source => 'puppet:///modules/jenkins/dmakepkg';

    '/chroot':
      ensure  => directory;

    '/etc/makepkg.conf':
      source  => 'puppet:///modules/jenkins/makepkg.conf';

    #'/etc/sudoers.d/jenkins':
    #  ensure  => absent,
    #  source  => 'puppet:///modules/jenkins/sudoers.d-jenkins';

    #'/usr/local/bin/update-sources':
    #  ensure  => absent,
    #  source  => 'puppet:///modules/jenkins/update-sources';

    #'/etc/cron.daily/update-sources':
    #  ensure  => absent,
    #  target  => '/usr/local/bin/update-sources';

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
      mode    => '0600',
      owner   => 'jenkins',
      group   => 'jenkins',
      source  => 'puppet:///modules/jenkins/authorized_keys',
      require => File['/var/lib/jenkins/.ssh'];
  }
}
