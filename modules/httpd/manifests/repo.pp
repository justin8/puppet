class httpd::repo inherits httpd {

  file { '/etc/httpd/conf/sites-available/repo.dray.be':
    ensure  => file,
    require => Package['apache'],
    source  => 'puppet:///modules/httpd/etc/httpd/conf/sites-available/repo.dray.be',
  }

  file { '/etc/httpd/conf/sites-enabled/repo.dray.be':
    ensure  => link,
    require => Package['apache'],
    target  => '../sites-available/repo.dray.be',
  }

}
