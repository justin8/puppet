define httpd::vhost ($destination = '*', $proxy) {
  include httpd
  $httpd_private_keys = hiera('httpd_private_keys')

  if $proxy == true {
    file { "/etc/httpd/conf/sites-available/${title}":
      ensure  => file,
      content => template('httpd/vproxy.erb'),
    }
  }
  else {
    file { "/etc/httpd/conf/sites-available/${title}":
      ensure  => file,
      source  => "puppet:///modules/httpd/etc/httpd/conf/sites-available/${title}",
    }
  }

  file {
    "/etc/httpd/conf/sites-enabled/${title}":
      ensure  => link,
      target  => "../sites-available/${title}",
      require => File["/etc/httpd/conf/sites-available/${title}"],
      notify  => Service['httpd'];

    "/etc/ssl/certs/${title}.crt":
      ensure => file,
      source => "puppet:///modules/httpd/etc/ssl/certs/${title}.crt",
      notify => Service['httpd'];

    "/etc/ssl/private/${title}.pem":
      ensure  => file,
      mode    => '0400',
      content => $httpd_private_keys[$title];
  }
}
