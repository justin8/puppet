class mediaserver::downloader {

  ensure_packages([
    'openvpn',
    'python2-pyopenssl',
    'sabnzbd',
    'transmission-cli',
    ])

  service {
    'openvpn@ghostpath':
      ensure  => running,
      enable  => true,
      require => File['/etc/openvpn/ghostpath.conf', '/etc/openvpn/ghostpath-auth'];

    ['transmission', 'sabnzbd']:
      enable => false;
  }

  cron {
    'vpn-checker':
      command  => '/usr/local/sbin/vpn-checker',
      user     => 'root',
      minute   => '*/5',
      hour     => '*',
      month    => '*',
      monthday => '*',
      weekday  => '*';
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

    '/usr/local/sbin/vpn-checker':
      mode   => '755',
      source => 'puppet:///modules/mediaserver/vpn-checker';

    '/etc/tmpfiles.d/sabnzbd.conf':
      source => 'puppet:///modules/mediaserver/sabnzbd.tmpfiles';
  }

  exec { 'sabnzbd-refresh':
    command     => '/usr/bin/systemd-tmpfiles --create',
    refreshonly => true,
    before      => Service['sabnzbd'],
    subscribe   => File['/etc/tmpfiles.d/sabnzbd.conf'];
  }

}
