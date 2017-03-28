class hass {

  vhost { 'hass':
    url      => 'hass.dray.be',
    upstream => 'localhost:8123',
    auth_basic_user_file => '/srv/htpasswd',
  }

  file { ['/var/lib/hass', '/var/lib/ha-bridge']:
    ensure => directory
  }

  file { '/usr/lib/hass':
    ensure => directory,
    recurse => true,
    source => "puppet:///modules/hass/hass",
  }

  file { '/usr/local/sbin/update-home-assistant-config':
    ensure => present,
    source => 'puppet:///modules/hass/update-home-assistant-config',
    mode   => '0755'
  }

  file { '/etc/systemd/system/hass.service':
    ensure => present,
    source => 'puppet:///modules/hass/hass.service',
    notify  => Exec['systemd-daemon-reload'],
  }

  service { 'hass':
    ensure => running,
    enable => true,
    require => File['/etc/systemd/system/hass.service'],
  }
}
