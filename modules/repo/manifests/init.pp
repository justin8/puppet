class repo {

  realize(
    Httpd::Vhost['repo.dray.be'],
  )

  file {
    '/srv/repo':
      ensure => directory;

    '/etc/incron.d/update-repo':
      ensure  => file,
      source  => 'puppet:///modules/repo/update-repo.incron',
      require => File['/usr/local/bin/update-repo'];

    '/etc/incron.allow':
      ensure  => file,
      content => "root\n";
    '/usr/local/bin/update-repo':
      ensure => file,
      mode   => '0755',
      source => 'puppet:///modules/repo/update-repo';
    '/usr/local/bin/build-new-packages':
      ensure => file,
      mode   => '0755',
      source => 'puppet:///modules/repo/build-new-packages';
  }

}
