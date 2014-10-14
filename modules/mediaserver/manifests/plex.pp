class mediaserver::plex {
  include httpd
  Httpd::Vhost <| title == 'plex.dray.be' |>

  $image = 'justin8/plexmediaserver'
  
  docker::image { $image:
    image_tag => 'latest',
    require   => Docker::Run['plexmediaserver'],
  }

  docker::run { 'plexmediaserver':
    image   => $image,
    ports   => ['32400'],
    volumes => ['/raid/server-files/config/plex:/config',
                '/raid/shares/:/media'],
  }

}
