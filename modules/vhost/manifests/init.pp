define vhost($url,
             $upstream = undef,
             $www_root = undef,
             $autoindex = 'off',
             $auth_basic_user_file = undef,
             $https = true,
             $sync = false,
) {
  include vhost::setup
  #  include php?

  if $operatingsystem == 'Archlinux' {
    $owner = 'http'
    $group = 'http'
  } elsif $operatingsystem == 'Ubuntu' {
    $owner = 'www-data'
    $group = 'www-data'
  }

  validate_bool($sync)
  validate_re($autoindex, '^(on|off)$')

  if www_root == undef and sync == True {
    fail('sync can only be used with www_root specified')
  }

  $vhost_private_keys = hiera('vhost_private_keys')
  $private_key = $vhost_private_keys[$url]
  validate_re($private_key, '^---.*$')

  if $auth_basic_user_file != undef {
    $auth_basic = "Restricted. ${url}"
  } else{
    $auth_basic = undef
  }

  file { "/etc/ssl/private/nginx/${url}.pem":
    content => $private_key,
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

  if $sync {
    $btsync_keys = hiera('btsync_keys')
    btsync::folder { $www_root:
      secret  => $btsync_keys[$title],
      owner   => $owner,
      group   => $owner,
      notify  => Service['nginx'],
      require => Nginx::Resource::Vhost[$url],
    }
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
      rewrite_to_https     => $https,
      ssl                  => $https,
      ssl_cert             => "/etc/ssl/certs/nginx/${url}.crt",
      ssl_key              => "/etc/ssl/private/nginx/${url}.pem",
      location_cfg_append  => {
        'proxy_set_header Host'                 => '$http_host',
        'proxy_set_header X-Real-IP'            => '$remote_addr',
      }
    }
  }

  # Webserver config
  if $www_root {
    nginx::resource::vhost { $url:
      www_root             => $www_root,
      auth_basic           => $auth_basic,
      auth_basic_user_file => $auth_basic_user_file,
      autoindex            => $autoindex,
      rewrite_to_https     => $https,
      ssl                  => $https,
      ssl_cert             => "/etc/ssl/certs/nginx/${url}.crt",
      ssl_key              => "/etc/ssl/private/nginx/${url}.pem",
    }
  }
}
