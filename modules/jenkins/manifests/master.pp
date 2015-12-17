class jenkins::master {
  include incron

  vhost { 'jenkins':
    url      => 'jenkins.dray.be',
    upstream => 'localhost:7090',
  }

  package { 'jenkins':
    ensure => installed;
  }

  service {
    'jenkins':
      ensure  => running,
      enable  => true,
      require => Package['jenkins']
  }

  file {
    '/etc/conf.d/jenkins':
      ensure => file,
      source => 'puppet:///modules/jenkins/conf.d-jenkins',
      notify => Service['jenkins'];
  }

}
