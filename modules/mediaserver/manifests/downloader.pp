class mediaserver::downloader {
  include httpd
  realize (
    Httpd::Vhost['sab.dray.be'],
    Httpd::Vhost['transmission.dray.be'],
  )

  package {
    [
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
  }

}
