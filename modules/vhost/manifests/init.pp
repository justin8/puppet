define vhost($url,
             $upstream = undef,
             $www_root = undef,
             $autoindex = 'off',
) {
  include nginx
  include vhost::setup
  #  include php?
  $vhost_private_keys = hiera('vhost_private_keys')

  file { "/etc/ssl/private/nginx/${url}.pem":
    content => $vhost_private_keys[$url],
    notify  => Service['nginx'],
  }

  file { "/etc/ssl/certs/nginx/${url}.crt":
    source => "puppet:///modules/vhost/certs/${url}.crt",
    notify => Service['nginx'],
  }

  if ! $upstream and ! $www_root {
    fail('You must specify either an upstream or a www_root')
  }

  if $upstream and $www_root {
    fail('You can only specify either an upstream or a www_root')
  }

  # Proxy config
  if $upstream {
    nginx::resource::upstream { $title:
      members => [$upstream],
    }

    nginx::resource::vhost { $url:
      proxy => "http://${title}",
      ssl   => true,
      ssl_cert => "/etc/ssl/certs/nginx/${url}.crt",
      ssl_key  => "/etc/ssl/private/nginx/${url}.pem",
    }
  }

  # Webserver config
  if $www_root {
    nginx::resource::vhost { $url:
      www_root  => $www_root,
      autoindex => $autoindex,
      ssl       => true,
      ssl_cert  => "/etc/ssl/certs/nginx/${url}.crt",
      ssl_key   => "/etc/ssl/private/nginx/${url}.pem",
    }
  }
}
