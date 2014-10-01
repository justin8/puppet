class repo( $owner = 'http', $group = 'http') {
  include httpd
  include incron
  realize ( Httpd::Vhost['repo.dray.be'], )

  package { 'pkgcacheclean':
    ensure => installed,
  }

  incron { 'update-repo':
    user    => 'root',
    command => '/usr/local/sbin/update-repo $@$#',
    path    => '/srv/repo',
    mask    => ['IN_CLOSE_WRITE', 'IN_MOVED_TO'],
  }

  cron { 'pkgcacheclean':
    command  => 'pkgcacheclean -k 5',
    minute   => '0',
    hour     => '4',
    month    => '*',
    weekday  => '*',
    monthday => '*',
    require  => Package['pkgcacheclean'],
  }

  file {
    ['/etc/cron.daily/pkgcacheclean.cron',
    '/usr/local/bin/update-repo']:
      ensure => absent;

    '/usr/local/sbin/update-repo':
      ensure => file,
      mode   => '0755',
      source => 'puppet:///modules/repo/update-repo';
  }

  btsync::folder {
    '/srv/repo':
      secret => 'AEB27GZEPUXIIL7CS6CB3RD57ZYBOO47B',
      owner  => $owner,
      group  => $group,
      notify => Service['httpd'];
  }
}
