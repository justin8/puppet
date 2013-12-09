class jenkins {

  $packages = [ 'jenkins-ci' ]
  package { $packages: ensure => installed }

  file {
    '/etc/conf.d/jenkins':
      ensure => file,
      source => 'puppet:///modules/jenkins/conf.d-jenkins';
  }
}
