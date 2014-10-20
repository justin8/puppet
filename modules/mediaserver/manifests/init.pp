class mediaserver {
  include docker

  class { [ 'mediaserver::plex',
            'mediaserver::sabnzbd' ]:
    config_dir => '/raid/server-files/config',
  }
  #include mediaserver::couchpotato
  #include mediaserver::drone
  #include mediaserver::transmission
}
