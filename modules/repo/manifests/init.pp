class repo {
  class { 'repo::mount': remote => false; }
  include httpd
  realize ( Httpd::Vhost['repo.dray.be'], )

  package { 'pkgcacheclean':
    ensure => installed,
  }

  file {
    '/etc/incron.allow':
      ensure  => file,
      content => "root\n";

    '/etc/incron.d/update-repo.incron':
      ensure  => file,
      source  => 'puppet:///modules/repo/update-repo.incron',
      require => File['/usr/local/bin/update-repo'];

    '/usr/local/bin/update-repo':
      ensure => file,
      mode   => '0755',
      source => 'puppet:///modules/repo/update-repo';

    '/etc/cron.daily/pkgcacheclean.cron':
      ensure => file,
      mode   => '0755',
      source => 'puppet:///modules/repo/pkgcacheclean.cron',
  }

}
