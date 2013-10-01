class misc {
  file { '/usr/local/bin/colourdiff':
    ensure  => file,
    mode    => '0775',
    source  => 'puppet:///modules/os_default/colourdiff',
  }

  file { '/etc/puppet/puppet.conf':
    ensure  => file,
    mode    => '0664',
    source  => 'puppet:///modules/os_default/puppet.conf',
  }

  file { '/etc/udev/rules.d/50-wol.rules':
    ensure  => file,
    mode    => '0664',
    source  => 'puppet:///modules/os_default/udev_50-wol.rules',
  }

  file { '/etc/bash.bashrc':
    ensure  => file,
    source  => 'puppet:///modules/os_default/etc/bash.bashrc',
  }

  file { '/etc/DIR_COLORS':
    ensure  => file,
    source  => 'puppet:///modules/os_default/etc/DIR_COLORS',
  }
}
