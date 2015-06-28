class vhost::setup {
  include monitoring::nginx

  file {
    '/etc/ssl/private':
      ensure  => directory,
      recurse => true,
      mode    => '0600';

    '/etc/ssl/private/nginx':
      ensure  => directory,
      recurse => true,
      purge   => true,
      force   => true,
      mode    => '0600';

    '/etc/ssl/certs':
      ensure  => directory,
      recurse => true,
      mode    => '0644';

    '/etc/ssl/certs/nginx':
      ensure  => directory,
      recurse => true,
      purge   => true,
      force   => true,
      mode    => '0644';

    '/etc/ssl/certs/sub.class1.server.ca.pem':
      ensure => present,
      source => 'puppet:///modules/vhost/sub.class1.server.ca.pem';

    '/etc/ssl/certs/ca.pem':
      ensure => present,
      source => 'puppet:///modules/vhost/ca.pem';
  }
}
