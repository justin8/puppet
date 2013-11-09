class blog::services {
  service { [ 'httpd', 'mysqld' ]:
    ensure => running,
    enable => true,
  }
}
