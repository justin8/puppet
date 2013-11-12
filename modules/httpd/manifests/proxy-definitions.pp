class httpd::proxy-definitions {
  @httpd::proxy {
    'sab.dray.be':
      destination => 'http://abachi:8080';
  }
}
