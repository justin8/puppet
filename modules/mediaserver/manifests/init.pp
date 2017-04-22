class mediaserver {
  vhost {
    'couchpotato':
      url      => 'couchpotato.dray.be',
      upstream => 'localhost:5050';

    'emby':
      url      => 'emby.dray.be',
      upstream => 'localhost:8096';

    'jackett':
      url      => 'jackett.dray.be',
      upstream => 'localhost:9117';

    'sonarr':
      url      => 'sonarr.dray.be',
      upstream => 'localhost:8989';

    'transmission':
      url      => 'transmission.dray.be',
      upstream => 'localhost:9091';
  }

  $vpn_username = hiera('vpn_username')
  $vpn_password = hiera('vpn_password')

  ensure_packages ([
    'docker',
    'docker-compose',
    'emby-server',
    'plex-media-server',
  ])

  # Plex/Emby
  service {
    #'emby-server':
    #  ensure  => running,
    #  enable  => true,
    #  require => Package['emby-server'];

    'plexmediaserver':
      ensure  => running,
      enable  => true,
      require => [
        File['/etc/systemd/system/plexmediaserver.service.d/downloads.conf'],
        Package['plex-media-server'],
      ];
  }

  file {
    '/etc/systemd/system/plexmediaserver.service.d':
      ensure => directory;

    '/etc/systemd/system/plexmediaserver.service.d/downloads.conf':
      source => 'puppet:///modules/mediaserver/downloads.conf';
  }

  # Dockerized apps
  file { '/etc/systemd/system/mediaserver.service':
    ensure => present,
    source => 'puppet:///modules/mediaserver/mediaserver.service',
    notify  => Exec['systemd-daemon-reload'],
  }

  service { 'mediaserver':
    ensure => running,
    enable => true,
    require => File['/etc/systemd/system/mediaserver.service',
                    '/usr/lib/mediaserver/docker-compose.yml'],
  }

  cron {
    'mediaserver-restart':
      command  => 'systemctl restart mediaserver',
      user     => 'root',
      minute   => '0',
      hour     => '4',
      month    => '*',
      monthday => '*',
      weekday  => '*';

    'check-mediaserver':
      command  =>  '/usr/lib/mediaserver/check-mediaserver',
      user     => 'root',
      minute   => '*/10',
      hour     => '*',
      month    => '*',
      monthday => '*',
      weekday  => '*';
  }

  file {
    [
      '/var/lib/mediaserver',
      '/var/lib/mediaserver/transmission',
      '/var/lib/mediaserver/sonarr',
      '/var/lib/mediaserver/couchpotato',
    ]:
      ensure => directory;

    '/usr/lib/mediaserver':
      ensure  => directory,
      source  => 'puppet:///modules/mediaserver/mediaserver',
      recurse => true;

    '/usr/lib/mediaserver/docker-compose.yml':
      content => template('mediaserver/docker-compose.yml.erb'),
      notify => Service['mediaserver'];
  }

}
