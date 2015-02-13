class owncloud {
  include httpd
  include mysql::server
  realize (Httpd::Vhost['cloud.dray.be'])

  package { ['exiv2', 'owncloud', 'php-apcu', 'php-intl', 'php-mcrypt']:
    ensure => installed
  }

  file {
    '/etc/php/conf.d/owncloud.ini':
      ensure  => present,
      source  => 'puppet:///modules/owncloud/owncloud.ini',
      notify  => Service['php-fpm'],
      require => Package['owncloud'];

    '/etc/cron.daily/backup-owncloud-db.cron':
      ensure => present,
      mode   => '0755',
      source => 'puppet:///modules/owncloud/backup-owncloud-db.cron',
      require => Package['owncloud'];

    '/usr/share/webapps/owncloud/database-backup':
      ensure => directory,
      require => Package['owncloud'];

    [ '/usr/share/webapps/owncloud/apps',
      '/usr/share/webapps/owncloud/data',
      '/etc/webapps/owncloud/config' ]:
      ensure  => directory,
      owner   => 'http',
      group   => 'http',
      recurse => true,
      require => Package['owncloud'];
  }

}
