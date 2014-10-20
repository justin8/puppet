class mediaserver {
  include docker

  include mediaserver::plex
  #include mediaserver::sabnzbd
  #include mediaserver::couchpotato
  #include mediaserver::drone
  #include mediaserver::transmission
}
