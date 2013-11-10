class httpd::blog inherits httpd {
  $packages = [ 'apache', 'mariadb', 'php', 'php-apache' ]
  package { $packages: ensure => installed }

  service { 'mysqld':
    ensure => running,
    enable => true,
  }

  file { '/etc/httpd/conf/sites-available/www.dray.be':
    ensure  => file,
    require => Package['apache'],
    source  => 'puppet:///modules/httpd/etc/httpd/conf/sites-enabled/www.dray.be',
  }

  file { '/etc/httpd/conf/sites-enabled/www.dray.be':
    ensure => link,
    require => Package['apache'],
    target => '../sites-available/www.dray.be',
  }

  file { '/etc/ssl/certs/www.dray.be.crt':
    ensure => file,
    source => 'puppet:///modules/httpd/etc/ssl/certs/www.dray.be.crt',
  }
}
