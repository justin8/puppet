define vhost::lets_encrypt() {
  include vhost::setup

  # script to register/renew
  file { "/srv/letsencrypt/${name}-renew-certificate.sh":
    ensure  => present,
    mode    => '0744',
    content => template('vhost/renew-certificate.sh.erb')
  }

  # config file for domain
  file { "/srv/letsencrypt/${name}-config.ini":
    ensure => present,
    mode    => '0744',
    content => template('vhost/letsencrypt-config.ini.erb')
  }

  # create path to /srv/letsencrypt/${name}/.well-known
  file {
    "/srv/letsencrypt/${name}":
      ensure => directory;

    "/srv/letsencrypt/${name}/.well-known":
      ensure => directory,
      require => File["/srv/letsencrypt/${name}"];

    "/srv/letsencrypt/${name}/.well-known/testfile":
      ensure => present,
      content => "testfile";
  }

  # run the script if the certificate doesn't exist
  exec { "renew-${name}":
    path    => '/usr/bin',
    command => "/srv/letsencrypt/${name}-renew-certificate.sh",
    require => [ File["/srv/letsencrypt/${name}-config.ini"], File["/srv/letsencrypt/${name}-renew-certificate.sh"] ],
    unless  => "test -e /etc/letsencrypt/live/${name}/fullchain.pem",
  }

  # monthly cron job to run the script
  cron { "${name}-renew-certificate.sh":
    command => "/srv/letsencrypt/${name}-renew-certificate.sh",
    user    => 'root',
    minute   => '0',
    hour     => '4',
    weekday  => '*',
    monthday => '1',
    month    => '*',
  }

}
