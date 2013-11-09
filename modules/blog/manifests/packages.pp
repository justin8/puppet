class blog::packages {
  $packages = [ 'apache', 'mariadb', 'php', 'php-apache', 'php-mcrypt', 'phpmyadmin' ]
  package { $packages: ensure => installed }
}
