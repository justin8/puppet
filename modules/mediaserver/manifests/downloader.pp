class mediaserver::downloader {

  $server1 = hiera('usenet_server_1')
  $port1 = hiera('usenet_port_1')
  $user1 = hiera('usenet_user_1')
  $password1 = hiera('usenet_password_1')
  $nzbget_password = hiera('nzbget_password')

  ensure_packages([
    'nzbget',
    'openvpn',
    'python2-pyopenssl',
    'transmission-cli',
    ])

  service {
    'openvpn@ghostpath':
      ensure  => running,
      enable  => true,
      require => File['/etc/openvpn/ghostpath.conf', '/etc/openvpn/ghostpath-auth'];

    ['transmission', 'nzbget']:
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
    '/etc/systemd/system/transmission.service.d':
      ensure => directory;

    '/etc/systemd/system/transmission.service.d/downloads.conf':
      source => 'puppet:///modules/mediaserver/downloads.conf';

    '/etc/systemd/system/nzbget.service':
      source => 'puppet:///modules/mediaserver/nzbget.service';

    '/etc/nzbget.conf':
      content => template('mediaserver/nzbget.conf.erb');

    '/etc/openvpn/ghostpath.conf':
      source => 'puppet:///modules/mediaserver/ghostpath.conf';

    '/etc/openvpn/ghostpath-auth':
      content => hiera('ghostpath_auth');

    '/usr/local/sbin/vpn-checker':
      mode   => '755',
      source => 'puppet:///modules/mediaserver/vpn-checker';
  }

}
