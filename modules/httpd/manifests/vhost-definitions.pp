class httpd::vhost-definitions {
  @httpd::vhost {
    'sab.dray.be':
      destination => 'http://sab.dray.be:8080',
      proxy => true;

    'sickbeard.dray.be':
      destination => 'http://sickbeard.dray.be:8081',
      proxy => true;
  }
}
