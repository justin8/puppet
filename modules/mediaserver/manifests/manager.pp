class mediaserver::manager {
  vhost {
    'couchpotato':
      url      => 'couchpotato.dray.be',
      upstream => 'localhost:5050';

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


  ensure_packages([
    'couchpotato',
    'plex-media-server',
    'sonarr-develop',
    ])

  service {
    'couchpotato':
      ensure  => running,
      enable  => true,
      require => File['/etc/systemd/system/couchpotato.service.d/downloads.conf'];

    'plexmediaserver':
      ensure  => running,
      enable  => true,
      require => File['/etc/systemd/system/plexmediaserver.service.d/downloads.conf'];

    'sonarr':
      ensure  => running,
      enable  => true,
      require => File['/etc/systemd/system/sonarr.service.d/downloads.conf'];
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
  }

}
