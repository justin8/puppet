class os_default::ntp {
  package { 'openntpd': ensure => absent, require => Package['networkmanager-dispatcher-openntpd'] }
  package { 'networkmanager-dispatcher-openntpd': ensure   => absent; }

  package { 'ntp': ensure => installed, require => Package['openntpd'] }

  if $networkmanager == 'true' {
    package {
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
