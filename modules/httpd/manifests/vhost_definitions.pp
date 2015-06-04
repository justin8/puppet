class httpd::vhost_definitions {
  # TODO: Add the ability to specify a proxy host from other modules
  @httpd::vhost {
    'abachi.dray.be':
      proxy => false;

    'grafana.dray.be':
      destination => 'http://localhost:3000',
      proxy       => true;

    'couchpotato.dray.be':
      destination => 'http://localhost:5050',
      proxy       => true;

    'sonarr.dray.be':
      destination => 'http://localhost:8989',
      proxy       => true;

    'jenkins.dray.be':
      destination => 'http://localhost:7090',
      proxy       => true;

    'plex.dray.be':
      destination => 'http://localhost:32400',
      proxy       => true;

    'repo.dray.be':
      proxy => false;

    'sab.dray.be':
      destination => 'http://hemlock:8080',
      proxy       => true;

    'sickbeard.dray.be':
      destination => 'http://localhost:8081',
      proxy       => true;

    'transmission.dray.be':
      destination => 'http://hemlock:9091',
      proxy       => true;

    'www.dray.be':
      proxy => false;
  }
}