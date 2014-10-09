class httpd::basic( $CGP = true ) {
include httpd

  if $CGP == true {
    vcsrepo { '/srv/http/CGP':
      ensure   => present,
      provider => 'git',
      source   => 'https://github.com/justin8/CGP',
      revision => 'master';
    }
  }

  file {
    "/etc/httpd/conf/sites-available/${fqdn}":
      ensure  => file,
      content => template('httpd/basic-site.erb'),
      notify  => Service['httpd'];

    "/etc/httpd/conf/sites-enabled/${fqdn}":
      ensure  => link,
      target  => "../sites-available/${fqdn}",
      notify  => Service['httpd'];
  }

}
