class mediaserver::manager {
  include httpd
  realize (
    Httpd::Vhost['couchpotato.dray.be'],
    Httpd::Vhost['plex.dray.be'],
    Httpd::Vhost['sab.dray.be'],
    Httpd::Vhost['sonarr.dray.be'],
    Httpd::Vhost['transmission.dray.be'],
  )

  ensure_packages(
    'couchpotato',
    'plex-media-server',
    'sonarr-develop',
  )

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
