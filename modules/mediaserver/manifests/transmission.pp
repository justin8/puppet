class mediaserver::transmission ( $config_dir ) {
  include httpd
  Httpd::Vhost <| title == 'transmission.dray.be' |>

  $image = 'justin8/transmission'
  $tag = 'latest'

  docker::image { $image:
    image_tag => $tag,
  }

  docker::run { 'transmission':
    image   => "${image}:${latest}",
    ports   => ['9091:9091'],
    volumes => ["${config_dir}/transmission:/config",
                '/raid/server-files/downloads:/downloads',],
    require => Docker::Image[$image],
  }

}
