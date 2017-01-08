class home {

  vhost { 'home':
    url      => 'home.dray.be',
    upstream => 'localhost:8123',
  }

  ensure_packages ([
    'home-assistant'
  ])

  service { 'home-assistant':
    ensure  => running,
    enable  => true,
    require => Package['home-assistant'],
  }
}
