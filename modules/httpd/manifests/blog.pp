class httpd::blog {
  include httpd
  $packages = [ 'mariadb' ]
  package { $packages: ensure => installed }

  service { 'mysqld':
    ensure => running,
    enable => true,
  }

  realize Httpd::Vhost['www.dray.be']
}
