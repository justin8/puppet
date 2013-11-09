class blog::packages {
  $packages = [ 'apache', 'mariadb', 'php', 'php-apache' ]
  package { $packages: ensure => installed }
}
