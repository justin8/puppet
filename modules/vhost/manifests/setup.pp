class vhost::setup {
  #include monitoring::nginx

  class { 'nginx':
    vhost_purge      => true,
    spdy             => 'true',
    worker_processes => 'auto',
    multi_accept     => 'true',
  }

  ensure_packages(['certbot'])

  file {
    '/srv/letsencrypt/':
      ensure => directory;

    '/srv/letsencrypt/live':
      ensure => directory;
  }

  file { '/srv/letsencrypt/dummycerts/':
    ensure => directory,
    recurse => true,
    source => 'puppet:///modules/vhost/dummycerts',
  }

  cron { "renew-certs":
    command => "/usr/bin/certbot renew",
    user    => 'root',
    minute   => '0',
    hour     => '4',
    weekday  => '*',
    monthday => '1',
    month    => '*',
  }

  nginx::resource::map { "connection_upgrade":
    ensure => present,
    default => 'upgrade',
    string => '$http_upgrade',
    mappings => {
      "''" => 'close'
    },
  }

}
