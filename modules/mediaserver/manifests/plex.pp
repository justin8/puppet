class mediaserver::plex ( $config_dir ) {
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
    volumes => ["${config_dir}/plex:/config",
                '/raid/shares:/media',
                '/raid/server-files/downloads:/downloads'],
    require   => Docker::Image[$image],
  }

}
