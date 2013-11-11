define httpd:vproxy ($name, $destination) {

  file {
    "/etc/httpd/conf/sites-available/${name}":
      ensure  => file,
      content => template("httpd/vproxy.erb");

    "/etc/httpd/conf/sites-enabled/${name}":
      ensure  => link,
      target  => "../sites-available/${name}",
      require => File["/etc/httpd/conf/sites-available/${name}"],
      notify  => Service['httpd'];
  }
}
