class jenkins::slave {

  $packages = [ 'jre8-openjdk-headless', 'abs', 'devtools' ]
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

    'create-chroot':
      path    => '/usr/bin',
      command => 'mkarchroot -C /etc/pacman.conf /chroot/root base-devel',
      unless  => 'test -d /chroot/root',
      timeout => 0,
      require => File['/chroot'],
      notify  => Exec['update-chroot-makepkg', 'update-chroot-pacman'];

    'update-chroot-makepkg':
      path    => '/usr/bin',
      command => 'cp /etc/makepkg.conf /chroot/root/etc/makepkg.conf',
      onlyif  => 'diff /etc/makepkg.conf /chroot/root/etc/makepkg.conf > /dev/null; [ $? -eq 1 ]',
      require => Exec['create-chroot'];

    'update-chroot-pacman':
      path    => '/usr/bin',
      command => 'cp /etc/pacman.conf /chroot/root/etc/pacman.conf',
      onlyif  => 'diff /etc/pacman.conf /chroot/root/etc/pacman.conf > /dev/null; [ $? -eq 1 ]',
      require => Exec['create-chroot'];
  }

  file {
    '/usr/bin/makechrootpkg-compat':
      ensure => absent;

    '/usr/local/bin/makechrootpkg-jenkins':
      ensure  => file,
      source  => 'puppet:///modules/jenkins/makechrootpkg-jenkins';

    '/chroot':
      ensure  => directory;

    '/etc/makepkg.conf':
      ensure  => file,
      source  => 'puppet:///modules/jenkins/makepkg.conf';

    '/etc/sudoers.d/jenkins':
      ensure  => file,
      source  => 'puppet:///modules/jenkins/sudoers.d-jenkins';

    '/usr/local/bin/update-sources':
      ensure  => file,
      source  => 'puppet:///modules/jenkins/update-sources';

    '/etc/cron.daily/update-sources':
      ensure  => link,
      target  => '/usr/local/bin/update-sources';

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
