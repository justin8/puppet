class repo( $readonly = false) {
  include incron

  if $operatingsystem == 'Ubuntu' {
    $owner = 'www-data'
    $group = 'www-data'
  } elsif $operatingsystem == 'Archlinux' {
    $owner = 'http'
    $group = 'http'
  }

  validate_bool($readonly)

  vhost { 'repo':
    url       => 'repo.dray.be',
    www_root  => '/srv/repo',
    autoindex => 'on',
  }

  s3sync {
    "arch-repo":
      path => '/srv/repo',
      bucket => 's3://jdray-arch-repo',
  }

  if $readonly == false {
    ensure_packages(['pkgcacheclean'])

    incron { 'update-repo':
      user    => 'root',
      command => '/usr/local/sbin/update-repo $@/$# && /usr/local/sbin/fix-package-cache &> /dev/null',
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

    logrotate::rule { 'update-repo':
      path => '/var/log/update-repo.log',
      rotate => 7,
      rotate_every => 'day',
    }

    file {
      '/usr/local/sbin/update-repo':
        ensure => file,
        mode   => '0755',
        source => 'puppet:///modules/repo/update-repo';
        
      '/usr/local/sbin/fix-package-cache':
        ensure => file,
        source => 'puppet:///modules/repo/fix-package-cache';
    }
  }
}
