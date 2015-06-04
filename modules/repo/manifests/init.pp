class repo( $owner = 'http', $group = 'http') {
  include httpd
  include incron
  realize Httpd::Vhost['repo.dray.be']
  $btsync_keys = hiera('btsync_keys')

  service { 'repo-proxy':
    ensure => stopped,
    enable => false,
  }

  file { 'repo-proxy.service':
    path    => '/etc/systemd/system/repo-proxy.service',
    ensure  => absent,
    require => Service['repo-proxy'],
  }

  package { 'pkgcacheclean':
    ensure => installed,
  }

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

  btsync::folder {
    '/srv/repo':
      secret      => $btsync_keys['repo'],
      owner       => $owner,
      group       => $group,
      use_upnp    => $open_network,
      use_dht     => $open_network,
      ignore_list => [ 'dray.be.*' ],
      notify      => Service['httpd'];
  }
}
