class misc {
  file { '/usr/local/bin/colourdiff':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0775',
    source  => 'puppet:///modules/os_default/colourdiff',
  }

  file { '/etc/puppet/puppet.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0775',
    source  => 'puppet:///modules/os_default/puppet.conf',
  }

  file { '/etc/udev/rules.d/50-wol.rules':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0664',
    source  => 'puppet:///modules/os_default/udev_50-wol.rules',
  }

  file { '/etc':
    ensure  => directory,
    recurse => true,
    owner   => 'root',
    group   => 'root',
    source  => 'puppet:///modules/os_default/etc',
  }
}
