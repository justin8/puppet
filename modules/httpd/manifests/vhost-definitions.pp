class httpd::vhost-definitions {
  # TODO: Add the ability to specify a proxy host from other modules
  @httpd::vhost {
    'abachi.dray.be':
      proxy => false;

    'couchpotato.dray.be':
      destination => 'http://localhost:5050',
      proxy       => true;

    'drone.dray.be':
      destination => 'http://localhost:8989',
      proxy       => true;

    'jenkins.dray.be':
      destination => 'http://localhost:8090',
      proxy       => true;

    'repo.dray.be':
      proxy => false;

    'sab.dray.be':
      destination => 'http://localhost:8080',
      proxy       => true;

    'sickbeard.dray.be':
      destination => 'http://localhost:8081',
      proxy       => true;

    'sync.dray.be':
      proxy => false;

    'transmission.dray.be':
      destination => 'http://localhost:9091',
      proxy       => true;

    'www.dray.be':
      proxy => false;
  }
}
