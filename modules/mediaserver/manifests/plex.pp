class mediaserver::plex {
  include httpd
  Httpd::Vhost <| title == 'plex.dray.be' |>

  $image = 'justin8/plexmediaserver'
  $tag = 'latest'

  docker::image { $image:
    image_tag => $tag,
  }

  docker::run { 'plexmediaserver':
    image   => "${image}:${tag}",
    ports   => ['32400:32400',
                '32400:32400/udp',
                '32469:32469',
                '32469:32469/udp',
                '1900:1900/udp',],
    volumes => ['/raid/server-files/config/plex:/config',
                '/raid/shares/anime:/media/anime',
                '/raid/shares/documentaries:/media/documentaries',
                '/raid/shares/movies:/media/movies',
                '/raid/shares/music:/media/music',
                '/raid/shares/music-videos:/media/music-videos',
                '/raid/shares/tv:/media/tv',
                '/raid/shares/videos:/media/videos',
                '/raid/server-files/downloads:/media/downloads'],
    require   => Docker::Image[$image],
  }

}
