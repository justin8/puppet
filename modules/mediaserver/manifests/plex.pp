class mediaserver::plex {
  include httpd
  Httpd::Vhost <| title == 'plex.dray.be' |>

  $image = 'justin8/plexmediaserver:latest'

  docker::image { $image:
    image_tag => 'latest',
  }

  docker::run { 'plexmediaserver':
    image   => $image,
    ports   => ['32400:32400',
                '32400:32400/udp',
                '32469:32469',
                '32469:32469/udp',
                '1900:1900/udp',],
    volumes => ['/raid/server-files/config/plex:/config',
                '/raid/shares/:/media'],
    require   => Docker::Image[$image],
  }

}
