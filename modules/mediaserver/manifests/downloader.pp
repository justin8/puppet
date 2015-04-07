class mediaserver::downloader {
  include httpd
  realize (
    Httpd::Vhost['sab.dray.be'],
    Httpd::Vhost['transmission.dray.be'],
  )

  package {
    [
      'openvpn',
      'sabnzbd',
      'transmission-cli',
    ]:
      ensure => present,
  }

  service {
    'sabnzbd':
      ensure  => running,
      enable  => true,
      require => File['/etc/systemd/system/sabnzbd.service.d/downloads.conf'];

    'transmission':
      ensure  => running,
      enable  => true,
      require => File['/etc/systemd/system/transmission.service.d/downloads.conf'];

    'openvpn@ghostpath':
      ensure  => running,
      enable  => true,
      require => File['/etc/openvpn/ghostpath.conf', '/etc/openvpn/ghostpath-auth'];
  }

  file {
    [
      '/etc/systemd/system/sabnzbd.service.d',
      '/etc/systemd/system/transmission.service.d'
    ]:
      ensure => directory;

    [
      '/etc/systemd/system/sabnzbd.service.d/downloads.conf',
      '/etc/systemd/system/transmission.service.d/downloads.conf'
    ]:
      source => 'puppet:///modules/mediaserver/downloads.conf';

    '/etc/openvpn/ghostpath.conf':
      source => 'puppet:///modules/mediaserver/ghostpath.conf';

    '/etc/openvpn/ghostpath-auth':
      content => hiera('ghostpath_auth');
  }

}
