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

  file {'/srv/letsencrypt/dummcerts/':
    ensure => directory,
    recurse => true,
    source => 'puppet:///modules/vhost/dummycerts',
  }

}
