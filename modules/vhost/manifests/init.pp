define vhost($url,
             $upstream = undef,
             $www_root = undef,
             $autoindex = 'off',
             $auth_basic_user_file = undef,
) {
  include vhost::setup
  #  include php?
  $vhost_private_keys = hiera('vhost_private_keys')

  if $auth_basic_user_file != undef {
    $auth_basic = "Restricted. ${url}"
  } else{
    $auth_basic = undef
  }

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
      proxy                => "http://${title}",
      auth_basic           => $auth_basic,
      auth_basic_user_file => $auth_basic_user_file,
      rewrite_to_https     => true,
      ssl                  => true,
      ssl_cert             => "/etc/ssl/certs/nginx/${url}.crt",
      ssl_key              => "/etc/ssl/private/nginx/${url}.pem",
    }
  }

  # Webserver config
  if $www_root {
    nginx::resource::vhost { $url:
      www_root             => $www_root,
      auth_basic           => $auth_basic,
      auth_basic_user_file => $auth_basic_user_file,
      autoindex            => $autoindex,
      rewrite_to_https     => true,
      ssl                  => true,
      ssl_cert             => "/etc/ssl/certs/nginx/${url}.crt",
      ssl_key              => "/etc/ssl/private/nginx/${url}.pem",
    }
  }
}
