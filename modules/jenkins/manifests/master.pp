class jenkins::master {
  include httpd
  realize Httpd::Vhost['jenkins.dray.be']

  $packages = [ 'jenkins' ]
  package { $packages: ensure => installed }

  service {
    'jenkins':
      ensure => running,
      enable => true;
  }

  file {
    '/etc/conf.d/jenkins':
      ensure => file,
      source => 'puppet:///modules/jenkins/conf.d-jenkins',
      notify => Service['jenkins'];

    '/usr/local/sbin/fix-package-cache':
      ensure => file,
      source => 'puppet:///modules/jenkins/fix-package-cache';
  }

  cron { 'fix-package-cache':
    command  => 'fix-package-cache',
    minute   => '0',
    hour     => '*',
    month    => '*',
    weekday  => '*',
    monthday => '*',
    require  => File['fix-package-cache'],
  }

}
