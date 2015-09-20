class mediaserver::manager {
  vhost {
    'couchpotato':
      url      => 'couchpotato.dray.be',
      upstream => 'localhost:5050';

    'emby':
      url      => 'emby.dray.be',
      upstream => 'localhost:8096';

    'sab':
      url      => 'sab.dray.be',
      upstream => 'hemlock:8080';

    'sonarr':
      url      => 'sonarr.dray.be',
      upstream => 'localhost:8989';

    'transmission':
      url      => 'transmission.dray.be',
      upstream => 'hemlock:9091';
  }


  package {
    ['couchpotato', 'emby-server', 'plex-media-server', 'sonarr-develop']:
      ensure => installed;
  }

  service {
    'couchpotato':
      ensure  => running,
      enable  => true,
      require => [
        File['/etc/systemd/system/couchpotato.service.d/downloads.conf'],
        Package['couchpotato'],
      ];

    'emby-server':
      ensure  => running,
      enable  => true,
      require => Package['emby-server'];

    'plexmediaserver':
      ensure  => running,
      enable  => true,
      require => [
        File['/etc/systemd/system/plexmediaserver.service.d/downloads.conf'],
        Package['plex-media-server'],
      ];

    'sonarr':
      ensure  => running,
      enable  => true,
      require => [
        File['/etc/systemd/system/sonarr.service.d/downloads.conf'],
        Package['sonarr-develop'],
      ];
  }

  exec { 'refresh-tmpfiles':
    command     => '/usr/bin/systemd-tmpfiles --create',
    refreshonly => true,
    before      => Service['sonarr', 'couchpotato'],
    subscribe   => File['/etc/tmpfiles.d/sonarr.conf'];
  }

  file {
    [
      '/etc/systemd/system/couchpotato.service.d',
      '/etc/systemd/system/plexmediaserver.service.d',
      '/etc/systemd/system/sonarr.service.d',
    ]:
      ensure => directory;

    [
      '/etc/systemd/system/couchpotato.service.d/downloads.conf',
      '/etc/systemd/system/plexmediaserver.service.d/downloads.conf',
      '/etc/systemd/system/sonarr.service.d/downloads.conf',
    ]:
      source => 'puppet:///modules/mediaserver/downloads.conf';

    '/etc/tmpfiles.d/couchpotato.conf':
      source => 'puppet:///modules/mediaserver/couchpotato.tmpfiles',
      notify => Exec['refresh-tmpfiles'];

    '/etc/tmpfiles.d/sonarr.conf':
      source => 'puppet:///modules/mediaserver/sonarr.tmpfiles',
      notify => Exec['refresh-tmpfiles'];
  }

}
