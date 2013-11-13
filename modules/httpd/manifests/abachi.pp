class httpd::abachi inherits httpd {

  file { '/etc/httpd/conf/sites-available/abachi.dray.be':
    ensure  => file,
    require => Package['apache'],
    source  => 'puppet:///modules/httpd/etc/httpd/conf/sites-available/abachi.dray.be',
  }

  file { '/etc/httpd/conf/sites-enabled/abachi.dray.be':
    ensure => link,
    require => Package['apache'],
    target => '../sites-available/abachi.dray.be',
  }

}
