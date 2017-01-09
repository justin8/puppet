class home {

  vhost { 'home':
    url      => 'home.dray.be',
    upstream => 'localhost:8123',
    auth_basic_user_file => '/srv/htpasswd',
  }

}
