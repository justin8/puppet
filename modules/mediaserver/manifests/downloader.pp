class mediaserver::downloader {

  $vpn_username = hiera('vpn_username')
  $vpn_password = hiera('vpn_password')

  ensure_packages([
    'docker',
    'docker-compose',
    ])

  cron {
    'mediaserver-checker':
      command  => '/usr/local/mediaserver/mediaserver-checker',
      user     => 'root',
      minute   => '*/5',
      hour     => '*',
      month    => '*',
      monthday => '*',
      weekday  => '*';
  }

  cron {
    'mediaserver-restart':
      command => '/usr/local/mediaserver/mediaserver-restart &>/dev/null',
      user     => 'root',
      minute   => '0',
      hour     => '4',
      month    => '*',
      monthday => '*',
      weekday  => '*';
  }

  file {
    '/usr/local/mediaserver':
      ensure => directory;

    '/usr/local/mediaserver/transmission':
      ensure => directory;

    '/usr/local/mediaserver/openvpn':
      ensure => directory;

    '/usr/local/mediaserver/docker-compose.yml':
      content => template('mediaserver/docker-compose.yml.erb');

    '/usr/local/mediaserver/openvpn/openvpn.conf':
      source => 'puppet:///modules/mediaserver/openvpn.conf';

    '/usr/local/mediaserver/openvpn/ca.crt':
      source => 'puppet:///modules/mediaserver/ca.crt';

    '/usr/local/mediaserver/openvpn/crl.pem':
      source => 'puppet:///modules/mediaserver/crl.pem';

    '/usr/local/mediaserver/openvpn/auth':
      content => hiera('openvpn_auth');

    '/usr/local/mediaserver/mediaserver-checker':
      mode   => '755',
      source => 'puppet:///modules/mediaserver/mediaserver-checker';

    '/usr/local/mediaserver/mediaserver-restart':
      mode   => '755',
      source => 'puppet:///modules/mediaserver/mediaserver-restart';
  }

}
