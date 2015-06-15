class jenkins::master {
  include httpd
  include incron
  realize Httpd::Vhost['jenkins.dray.be']

  ensure_packages(['jenkins'])

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

  incron { 'fix-package-cache':
    user     => 'root',
    command  => '/usr/local/sbin/fix-package-cache &> /dev/null',
    path     => '/srv/repo',
    mask     => ['IN_CLOSE_WRITE', 'IN_MOVED_TO'],
    require  => File['/usr/local/sbin/fix-package-cache'],
  }

}
