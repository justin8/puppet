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
      secret => 'AFL725PL2GCDL77OF6FCD5UFRCP42Z6LY',
      owner  => 'btsync',
      group  => 'btsync',
      notify => Service['httpd'];

    '/srv/sync/public/misc':
      secret => 'ASR5MFIRMUJ7D2KLIMMSDNMP3SCIAA4WZ',
      owner  => 'btsync',
      group  => 'btsync',
      notify => Service['httpd'];

    '/srv/sync/private':
      secret => 'AAB4H3CI3NRHPGAAAI4UERXTJC2H4YYVH',
      owner  => 'btsync',
      group  => 'btsync',
      notify => Service['httpd'];
  }

}
