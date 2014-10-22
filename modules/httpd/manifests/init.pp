class httpd {
  include httpd::vhost-definitions
  $packages = [ 'apache', 'php', 'php-fpm' ]
  package { $packages: ensure => installed }

  service { [ 'httpd', 'php-fpm' ]:
    ensure => running,
    enable => true,
  }

  file {
    '/etc/php/php.ini':
      ensure  => present,
      require => Package['php'],
      notify  => Service['php-fpm'],
      source  => 'puppet:///modules/httpd/etc/php/php.ini';

    '/etc/php/php-fpm.conf':
      ensure  => present,
      require => Package['php-fpm'],
      notify  => Service['php-fpm'],
      source  => 'puppet:///modules/httpd/etc/php/php-fpm.conf';

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
