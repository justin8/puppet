define vhost($url,
             $upstream = undef,
             $www_root = undef,
             $autoindex = 'off',
             $auth_basic_user_file = undef,
             $sync = false,
             $s3sync = false, # Set s3sync to the bucket to sync to
) {
  include vhost::setup
  #  include php?

  if $osfamily == 'Archlinux' {
    $owner = 'http'
    $group = 'http'
  } elsif $osfamily == 'Debian' {
    $owner = 'www-data'
    $group = 'www-data'
  }

  validate_bool($sync)
  validate_re($autoindex, '^(on|off)$')

  if www_root == undef and sync == True {
    fail('sync can only be used with www_root specified')
  }

  if $auth_basic_user_file != undef {
    $auth_basic = "Restricted. ${url}"
  } else{
    $auth_basic = undef
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

  if $s3sync != false {
    s3sync {
      $www_root:
        path => $www_root,
        bucket => $s3sync,
        poll => true,
    }
  }

  vhost::lets_encrypt { $url:
    require => Nginx::Resource::Vhost[$url],
  }

  file { "/etc/letsencrypt/live/$url":
    ensure => directory
  }

  exec { "copy-dummy-certs-$url":
    command => "rsync -r /srv/letsencrypt/dummycerts/ /etc/letsencrypt/live/$url/",
    unless => "test -e /etc/letsencrypt/live/$url/fullchain.pem",
    before => Nginx::Resource::Vhost[$url],
    notify => Service['nginx'],
  }

  $ssl_cert = "/etc/letsencrypt/live/${url}/fullchain.pem"
  $ssl_key = "/etc/letsencrypt/live/${url}/privkey.pem"

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
      ssl_cert             => $ssl_cert,
      ssl_key              => $ssl_key,
      location_cfg_append  => {
        'proxy_http_version'          =>  '1.1',
        'proxy_set_header Host'       => '$http_host',
        'proxy_set_header X-Real-IP'  => '$remote_addr',
        'proxy_set_header Upgrade'    => '$http_upgrade',
        'proxy_set_header Connection' => '$connection_upgrade',
      },
      location_raw_append  => "
  }

  location /.well-known {
    alias /srv/letsencrypt/${url}/.well-known;
    auth_basic          off;
",
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
      ssl_cert             => $ssl_cert,
      ssl_key              => $ssl_key,
      location_raw_append  => "
  }

  location /.well-known {
    alias /srv/letsencrypt/${url}/.well-known;
    auth_basic          off;
",
    }
  }
}
