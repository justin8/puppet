class httpd {
  $packages = [ 'apache', 'php', 'php-apache' ]
  package { $packages: ensure => installed }

  service { 'httpd':
    ensure => running,
    enable => true,
  }

  file { '/etc/php/php.ini':
    ensure  => present,
    require => Package['php'],
    notify  => Service['httpd'],
    source  => 'puppet:///modules/httpd/etc/php/php.ini',
  }

  file { '/etc/httpd/conf/httpd.conf':
    ensure  => present,
    require => Package['apache'],
    source  => 'puppet:///modules/httpd/etc/httpd/conf/httpd.conf',
    notify  => Service['httpd'];
  }

  file { [ '/etc/httpd/conf/sites-available', '/etc/httpd/conf/sites-enabled' ]:
    ensure  => directory,
    require => Package['apache'],
  }

  file {
    '/etc/ssl/private':
      ensure   => directory,
      recurse => true,
      mode    => '0640';

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
