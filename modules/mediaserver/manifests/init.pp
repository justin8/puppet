class mediaserver {
  vhost {
    'couchpotato':
      url      => 'couchpotato.dray.be',
      upstream => 'localhost:5050';

    'emby':
      url      => 'emby.dray.be',
      upstream => 'localhost:8096';

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
                    '/usr/lib/mediaserver/docker-compose.yml',
                    '/usr/lib/mediaserver/mediaserver'],
  }

  cron {
    'mediaserver-restart':
      command => 'systemctl restart mediaserver',
      user     => 'root',
      minute   => '0',
      hour     => '4',
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
      '/usr/lib/mediaserver',
    ]:
      ensure => directory;

    '/usr/lib/mediaserver/docker-compose.yml':
      content => template('mediaserver/docker-compose.yml.erb'),
      notify => Service['mediaserver'];

    '/usr/lib/mediaserver/mediaserver':
      mode   => '755',
      source => 'puppet:///modules/mediaserver/mediaserver',
      notify => Service['mediaserver'];

    '/var/lib/mediaserver/openvpn':
      source  => 'puppet:///modules/mediaserver/openvpn',
      recurse =>  true,
      notify  => Service['mediaserver'];
  }

}
