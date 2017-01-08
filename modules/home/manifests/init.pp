class home {

  vhost { 'home':
    url      => 'home.dray.be',
    upstream => 'localhost:8123',
  }

}
