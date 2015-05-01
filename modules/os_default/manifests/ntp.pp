class os_default::ntp {
  package { 'openntpd': ensure => absent, require => Service['openntpd'] }

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
        requires => Package['openntpd'];

      'networkmanager-dispatcher-ntpd':
        ensure   => installed,
        requires => Package['ntp'];
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
    service { 'ntp':
      ensure    => running,
      enable    => true,
      subscribe => File['/etc/localtime'],
    }
  }
}
