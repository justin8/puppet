class blog::packages {
  $packages = [ 'apache', 'mariadb', 'php', 'php-apache', 'phpmyadmin' ]
  package { $packages: ensure => installed }
}
