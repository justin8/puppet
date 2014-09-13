class btsync::server {

  require btsync
  Httpd::Vhost <| title == 'sync.dray.be' |>

}
