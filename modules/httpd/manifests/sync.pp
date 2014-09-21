class httpd::sync {

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

  # TODO: Test recurse with sticky bit for dirs
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


  btsync::folder {
    '/srv/sync/public/packages':
      secret => 'AM63EC4VXIWKDHO3IEZYBNV3Z2PO2WN3U',
      owner  => 'btsync',
      group  => 'btsync',
      notify => Service['httpd'];

    '/srv/sync/public/misc':
      secret => 'AKU7U4ASOVBAEYILA7NSMM2WB54HKY6CH',
      owner  => 'btsync',
      group  => 'btsync',
      notify => Service['httpd'];

    '/srv/sync/private':
      secret => 'AKWW375YPMCQRMQ3F4I6VCPIPS67POH27',
      owner  => 'btsync',
      group  => 'btsync',
      notify => Service['httpd'];
  }

}
