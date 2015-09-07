class repo( $readonly = false) {
  include incron
  $btsync_keys = hiera('btsync_keys')

  if $readonly == true {
    $key = $btsync_keys['repo_ro']
  } else {
    $key = $btsync_keys['repo']
  }

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

  btsync::folder {
    '/srv/repo':
      secret      => $key,
      owner       => $owner,
      group       => $group,
      use_upnp    => $open_network,
      use_dht     => $open_network,
      ignore_list => [ 'dray.be.*' ],
      notify      => Service['nginx'];
  }

  file {
    '/srv/repo/dray.be.db':
      ensure => link,
      owner  => $owner,
      group  => $group,
      target => '/srv/repo/dray.be.db.tar.gz';

    '/srv/repo/dray.be.files':
      ensure => link,
      owner  => $owner,
      group  => $group,
      target => '/srv/repo/dray.be.files.tar.gz';
  }

  if $readonly == False {
    ensure_packages(['pkgcacheclean'])

    incron { 'update-repo':
      user    => 'root',
      command => '/usr/local/sbin/update-repo $@/$#',
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

    file {'/usr/local/sbin/update-repo':
      ensure => file,
      mode   => '0755',
      source => 'puppet:///modules/repo/update-repo';
    }
  }
}
