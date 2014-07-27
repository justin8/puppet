class httpd::vhost-definitions {
  # TODO: Add the ability to specify a proxy host from other modules
  @httpd::vhost {
    'abachi.dray.be':
      proxy => false;

    'couchpotato.dray.be':
      destination => 'http://couchpotato.dray.be:5050',
      proxy       => true;

    'jenkins.dray.be':
      destination => 'http://jenkins.dray.be:8090',
      proxy       => true;

    'repo.dray.be':
      proxy => false;

    'sab.dray.be':
      destination => 'http://sab.dray.be:8080',
      proxy       => true;

    'sickbeard.dray.be':
      destination => 'http://sickbeard.dray.be:8081',
      proxy       => true;

    'transmission.dray.be':
      destination => 'http://transmission.dray.be:9091',
      proxy       => true;

    'www.dray.be':
      proxy => false;
  }
}
