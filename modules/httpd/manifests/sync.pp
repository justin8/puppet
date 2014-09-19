class httpd::btsync {

  require btsync::system
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

}
