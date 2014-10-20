class mediaserver {
  include docker

  class { [ 'mediaserver::plex',
            'mediaserver::couchpotato',
            'mediaserver::drone',
            'mediaserver::transmission',
            'mediaserver::sabnzbd' ]:
    config_dir => '/raid/server-files/config',
  }
}
