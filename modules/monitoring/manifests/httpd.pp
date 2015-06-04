class monitoring::httpd {
  include monitoring

  diamond::collector { 'HttpdCollector': }
}
