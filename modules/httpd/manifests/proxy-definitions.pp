class httpd::proxy-definitions {
  @httpd::vproxy {
    'sab.dray.be':
      destination => 'http://sab.dray.be:8080';
  }
}
