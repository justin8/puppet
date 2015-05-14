class os_default::ntp {
  package { 'openntpd': ensure => absent }

  package { 'ntp': ensure => installed, require => Package['openntpd'] }

  file { '/etc/localtime':
    ensure  => link,
    require => Package['openntpd'],
    target  => '/usr/share/zoneinfo/Australia/Brisbane',
  }

  if $networkmanager == 'true' {
    package {
      'networkmanager-dispatcher-openntpd':
        ensure   => absent,
        require => Package['openntpd'];

      'networkmanager-dispatcher-ntpd':
        ensure   => installed,
        require => Package['ntp'];
    }

    service { 'NetworkManager-dispatcher':
      ensure    => running,
      enable => true;
    }

    service { 'openntpd':
      enable    => false,
    }
  }
  else {
    service { 'ntpd':
      ensure    => running,
      enable    => true,
      subscribe => File['/etc/localtime'],
      require  => Package['ntp'],
    }
  }
}
