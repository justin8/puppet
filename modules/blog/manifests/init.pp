class blog {
  include blog::packages

  file '/etc/php/php.ini':
    ensure  => present,
    require => Package['php'],
    source  => 'puppet:///modules/blog/etc/php/php.ini',
  }

  file '/usr/share/webapps/phpMyAdmin/config':
    ensure  => directory,
    mode    => '0775',
    owner   => 'http',
    group   => 'http',
    require => [ Package['phpmyadmin'], Package['apache'],
}
