class blog {
  include blog::packages

  file { '/etc/php/php.ini':
    ensure  => present,
    require => Package['php'],
    source  => 'puppet:///modules/blog/etc/php/php.ini',
  }

  file { '/usr/share/webapps/phpMyAdmin/config':
    ensure  => directory,
    mode    => '0775',
    owner   => 'http',
    group   => 'http',
    require => [ Package['phpmyadmin'], Package['apache'] ],
  }

  file { '/etc/httpd/conf/httpd.conf':
    ensure  => present,
    require => Package['apache'],
    source  => 'puppet:///modules/blog/etc/httpd/conf/httpd.conf',
  }

  file { '/etc/httpd/conf/sites-available':
    ensure  => directory,
    require => Package['apache'],
    recurse => true,
    purge   => true,
    force   => true,
    source  => 'puppet:///modules/blog/etc/httpd/conf/sites-available',
  }

  file { '/etc/httpd/conf/sites-enabled':
    ensure  => directory,
    require => Package['apache'],
  }
}
