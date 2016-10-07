class mediaserver::manager {
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
  cron {
    'mediaserver-checker':
      command  => '/usr/local/mediaserver/mediaserver-checker',
      user     => 'root',
      minute   => '*/5',
      hour     => '*',
      month    => '*',
      monthday => '*',
      weekday  => '*';
  }

  cron {
    'mediaserver-restart':
      command => '/usr/local/mediaserver/mediaserver-restart &>/dev/null',
      user     => 'root',
      minute   => '0',
      hour     => '4',
      month    => '*',
      monthday => '*',
      weekday  => '*';
  }

  file {
    [
      '/usr/local/mediaserver',
      '/usr/local/mediaserver/openvpn',
      '/usr/local/mediaserver/transmission',
      '/usr/local/mediaserver/sonarr',
      '/usr/local/mediaserver/couchpotato',
    ]:
      ensure => directory;

    '/usr/local/mediaserver/docker-compose.yml':
      content => template('mediaserver/docker-compose.yml.erb');

    '/usr/local/mediaserver/openvpn/openvpn.conf':
      source => 'puppet:///modules/mediaserver/openvpn.conf';

    '/usr/local/mediaserver/openvpn/ca.crt':
      source => 'puppet:///modules/mediaserver/ca.crt';

    '/usr/local/mediaserver/openvpn/crl.pem':
      source => 'puppet:///modules/mediaserver/crl.pem';

    '/usr/local/mediaserver/mediaserver-checker':
      mode   => '755',
      source => 'puppet:///modules/mediaserver/mediaserver-checker';

    '/usr/local/mediaserver/mediaserver-restart':
      mode   => '755',
      source => 'puppet:///modules/mediaserver/mediaserver-restart';
  }

}
