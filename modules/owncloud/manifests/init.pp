class owncloud {
  include httpd
  realize (Httpd::Vhost['cloud.dray.be'])

  package { ['exiv2', 'mariadb', 'owncloud', 'php-apcu', 'php-intl', 'php-mcrypt']:
    ensure => installed
  }

  service { 'mysqld':
    ensure  => running,
    enable  => true,
    require => Package['mariadb'];
  }

  file {
    '/etc/php/conf.d/owncloud.ini':
      ensure => present,
      source => 'puppet:///modules/owncloud/owncloud.ini',
      notify => Service['php-fpm'];

    [ '/usr/share/webapps/owncloud', '/etc/webapps/owncloud' ]:
      ensure => directory,
      owner  => 'http',
      group  => 'http';
  }

}
