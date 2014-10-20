class mediaserver {
  include docker

  $config_dir = '/raid/server-files/config'

  include mediaserver::plex
  #include mediaserver::sabnzbd
  #include mediaserver::couchpotato
  #include mediaserver::drone
  #include mediaserver::transmission
}
