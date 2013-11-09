class blog {
  include blog::packages
  include blog::services

  file { '/etc/php/php.ini':
    ensure  => present,
    require => Package['php'],
    notify  => Service['httpd'],
    source  => 'puppet:///modules/blog/etc/php/php.ini',
  }

  file { '/usr/share/webapps/phpMyAdmin/config':
    ensure  => directory,
    mode    => '0775',
    owner   => 'http',
    group   => 'http',
    notify  => Service['httpd'],
    require => [ Package['phpmyadmin'], Package['apache'] ],
  }

  file { '/etc/httpd/conf/httpd.conf':
    ensure  => present,
    require => Package['apache'],
    source  => 'puppet:///modules/blog/etc/httpd/conf/httpd.conf',
    notify  => Service['httpd'],
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
    recurse => true,
    purge   => true,
    force   => true,
    source  => 'puppet:///modules/blog/etc/httpd/conf/sites-enabled',
  }

  file { '/etc/httpd/conf/extra':
    ensure  => directory,
    require => Package['apache'],
    recurse => true,
    force   => true,
    source  => 'puppet:///modules/blog/etc/httpd/conf/extra'
  }
}
