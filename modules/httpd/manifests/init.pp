class httpd {
  include httpd::vhost_definitions
  include monitoring::httpd
  package { [ 'apache', 'php-fpm']:
    ensure => installed
  }

  service {
    'httpd':
      ensure  => running,
      enable  => true,
      require => Package['apache'];

    'php-fpm':
      ensure  => running,
      enable  => true,
      require => Package['php-fpm'];
  }

  file { '/etc/php/php.ini':
    ensure  => present,
    source  => 'puppet:///modules/httpd/etc/php/php.ini',
    notify  => Service['php-fpm'],
    require => Package['php-fpm'],
  }

  file { '/etc/httpd/conf/httpd.conf':
    ensure  => present,
    source  => 'puppet:///modules/httpd/etc/httpd/conf/httpd.conf',
    notify  => Service['httpd'],
    require => Package['apache'];
  }

  file { [ '/etc/httpd/conf/sites-available', '/etc/httpd/conf/sites-enabled' ]:
    ensure  => directory,
    recurse => true,
    purge   => true,
    require => Package['apache'],
  }

  file {
    '/etc/ssl/private':
      ensure  => directory,
      recurse => true,
      mode    => '0600';

    '/etc/ssl/certs':
      ensure  => directory,
      recurse => true,
      mode    => '0644';

    '/etc/ssl/certs/sub.class1.server.ca.pem':
      ensure => present,
      source => 'puppet:///modules/httpd/etc/ssl/certs/sub.class1.server.ca.pem';

    '/etc/ssl/certs/ca.pem':
      ensure => present,
      source => 'puppet:///modules/httpd/etc/ssl/certs/ca.pem';
  }
}
