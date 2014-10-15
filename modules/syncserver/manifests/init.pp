class syncserver( $open_network = true ) {
  include httpd
  Httpd::Vhost <| title == 'sync.dray.be' |>

  exec { 'httpd btsync membership':
    command => 'usermod -a -G btsync http',
    unless  => 'groups http | grep btsync',
    notify  => Service['httpd'],
  }

  file { ['/var/lib/btsync/DavLock.dir',
          '/var/lib/btsync/DavLock.pag']:
    owner => 'http',
    group => 'http',
  }

  file { ['/srv/sync', '/srv/sync/public']:
    ensure => directory,
    owner  => 'btsync',
    group  => 'btsync',
    mode   => '2775',
  }

  cron { '/srv/sync perms':
    command  => '/usr/bin/chmod -R g+w /srv/sync',
    minute   => '*',
    hour     => '*',
    month    => '*',
    monthday => '*',
    weekday  => '*',
  }

  exec { '/srv/sync permissions':
    command => 'setfacl -d -m g::rwx /srv//sync',
    unless  => 'getfacl /srv//sync | grep default',
    require => File['/srv/sync'],
  }

  $btsync_keys = hiera('btsync_keys')

  btsync::folder {
    '/srv/sync/public/packages':
      secret   => $btsync_keys['public_packages'],
      owner    => 'btsync',
      group    => 'btsync',
      use_upnp => $open_network,
      notify   => Service['httpd'];

    '/srv/sync/public/misc':
      secret   => $btsync_keys['public_misc'],
      owner    => 'btsync',
      group    => 'btsync',
      use_upnp => $open_network,
      notify   => Service['httpd'];

    '/srv/sync/private':
      secret   => $btsync_keys['private'],
      owner    => 'btsync',
      group    => 'btsync',
      use_upnp => $open_network,
      notify   => Service['httpd'];
  }

}
