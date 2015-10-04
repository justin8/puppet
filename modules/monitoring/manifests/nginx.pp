class monitoring::nginx {
  include monitoring
  include nginx

  $nginx_telegraf = true

  nginx::resource::vhost { 'localhost-status':
    listen_ip => '127.0.0.1',
    listen_port => '4321',
    use_default_location => false,
  }

  nginx::resource::location { 'nginx_status':
    location    => '/nginx_status',
    location_allow => ['127.0.0.1'],
    vhost       => 'localhost-status',
    stub_status => true,
  }
  }
