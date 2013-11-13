define httpd::vproxy ($destination) {
  file {
    "/etc/httpd/conf/sites-available/${title}":
      ensure  => file,
      content => template("httpd/vproxy.erb");

    "/etc/httpd/conf/sites-enabled/${title}":
      ensure  => link,
      target  => "../sites-available/${title}",
      require => File["/etc/httpd/conf/sites-available/${title}"],
      notify  => Service['httpd'];

    "/etc/ssl/certs/${title}.crt":
      ensure => file,
      source => "puppet:///modules/httpd/etc/ssl/certs/${title}.crt";
  }
}
