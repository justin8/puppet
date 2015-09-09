class os_default::sudo {
  ensure_packages(['sudo'])

  group { 'wheel':
    ensure => present,
  }

  file { '/etc/sudoers.d':
    ensure  => directory,
    recurse => true,
    owner   => 'root',
    group   => 'root',
    mode    => '0440',
    source  => 'puppet:///modules/os_default/etc/sudoers.d',
    require => Package['sudo'],
  }

  file { '/etc/sudoers':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0440',
    source  => 'puppet:///modules/os_default/etc/sudoers',
    require => Package['sudo'],
  }
}
