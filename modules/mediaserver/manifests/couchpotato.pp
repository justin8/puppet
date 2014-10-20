class mediaserver::couchpotato ( $config_dir ) {
  include httpd
  Httpd::Vhost <| title == 'couchpotato.dray.be' |>

  $image = 'justin8/couchpotato'
  $tag = 'latest'

  docker::image { $image:
    image_tag => $tag,
  }

  docker::run { 'couchpotato':
    image   => "${image}:${latest}",
    ports   => ['5050:5050'],
    volumes => ["${config_dir}/couchpotato:/config",
                '/raid/server-files/downloads:/downloads',],
    require => Docker::Image[$image],
  }

}
