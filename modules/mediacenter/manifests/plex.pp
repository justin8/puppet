class plex ( $user ) {
  $packages = [ 'plex-home-theater' ]
  package { $packages: ensure => installed }

}
