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
