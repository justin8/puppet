class httpd::proxy-definitions {
  @httpd::vproxy {
    'sab.dray.be':
      destination => 'http://sab.dray.be:8080';

    'sickbeard.dray.be':
      destination => 'http://sickbeard.dray.be:8081';
  }
}
