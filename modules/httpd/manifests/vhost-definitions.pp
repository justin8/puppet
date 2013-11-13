class httpd::vhost-definitions {
  @httpd::vhost {
    'abachi.dray.be':
      proxy => false;

    'couchpotato.dray.be':
      destination => 'http://couchpotato.dray.be:5050',
      proxy => true;

    'deluge.dray.be':
      destination => 'http://deluge.dray.be:8112',
      proxy => true;

    'repo.dray.be':
      proxy => false;

    'sab.dray.be':
      destination => 'http://sab.dray.be:8080',
      proxy => true;

    'sickbeard.dray.be':
      destination => 'http://sickbeard.dray.be:8081',
      proxy => true;

    'www.dray.be':
      proxy => false;
  }
}
