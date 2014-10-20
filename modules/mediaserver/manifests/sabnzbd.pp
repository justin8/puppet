class mediaserver::sabnzbd ( $config_dir ) {
  include httpd
  Httpd::Vhost <| title == 'sab.dray.be' |>

  $image = 'justin8/sabnzbd'
  $tag = 'latest'

  docker::image { $image:
    image_tag => $tag,
  }

  docker::run { 'sabbnzbd':
    image   => "${image}:${latest}",
    ports   => ['8080:8080'],
    volumes => ["${config_dir}/sabnzbd:/config",
                '/raid/server-files/downloads:/downloads'],
    require => Docker::Image[$image],
  }
 
}
