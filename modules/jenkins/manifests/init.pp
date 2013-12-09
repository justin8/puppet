class jenkins {

  $packages = [ 'jenkins-ci' ]
  package { $packages: ensure => installed }

  include httpd
  realize(
    Httpd::Vhost['jenkins.dray.be'],
  )

  service {
    'jenkins':
      ensure => running,
      enable => true;
  }

  file {
    '/etc/conf.d/jenkins':
      ensure => file,
      source => 'puppet:///modules/jenkins/conf.d-jenkins'
      notify => Service['jenkins'];
  }
}
