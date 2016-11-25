define vhost::lets_encrypt() {
  include vhost::setup

  # script to register and generate a certificate
  file { "/srv/letsencrypt/${name}-generate-certificate.sh":
    ensure  => present,
    mode    => '0744',
    content => template('vhost/generate-certificate.sh.erb')
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

  # run the script if the current certificate is the dummy certificate
  exec { "generate-${name}":
    path    => '/usr/bin',
    command => "/srv/letsencrypt/${name}-generate-certificate.sh",
    require => [ File["/srv/letsencrypt/${name}-config.ini"], File["/srv/letsencrypt/${name}-generate-certificate.sh"], Service["nginx"] ],
    onlyif  => "test b1a17d1a619ba4695c51bf6d481f42f6 = `md5sum /etc/letsencrypt/live/${name}/fullchain.pem |  awk '{print \$1}'`",
  }

}
