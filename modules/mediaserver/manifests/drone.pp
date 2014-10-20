class mediaserver::drone ( $config_dir ) {
  include httpd
  Httpd::Vhost <| title == 'drone.dray.be' |>

  $image = 'justin8/nzbdrone-torrents'
  $tag = 'latest'

  docker::image { $image:
    image_tag => $tag,
  }

  docker::run { 'nzbdrone-torrents':
    image   => "${image}:${latest}",
    ports   => ['8989:8989'],
    volumes => ["${config_dir}/nzbdrone-torrents:/config",
                '/raid/server-files/downloads:/downloads',],
    require => Docker::Image[$image],
  }

}
