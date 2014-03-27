class os_default::misc {
  file {
    '/usr/local/bin/colourdiff':
      ensure  => file,
      mode    => '0775',
      source  => 'puppet:///modules/os_default/colourdiff';

    '/usr/local/bin/snap':
      ensure  => file,
      mode    => '0775',
      source  => 'puppet:///modules/os_default/snap';

    '/etc/puppet/puppet.conf':
      ensure  => file,
      mode    => '0664',
      source  => 'puppet:///modules/os_default/puppet.conf';

    '/etc/udev/rules.d/50-wol.rules':
      ensure  => file,
      mode    => '0664',
      source  => 'puppet:///modules/os_default/udev_50-wol.rules';

    '/etc/bash.bashrc':
      ensure  => file,
      source  => 'puppet:///modules/os_default/etc/bash.bashrc';

    '/etc/DIR_COLORS':
      ensure  => file,
      source  => 'puppet:///modules/os_default/etc/DIR_COLORS';

    '/etc/locale.conf':
      ensure  => file,
      source  => 'puppet:///modules/os_default/etc/locale.conf';

    '/etc/locale.gen':
      ensure  => file,
      source  => 'puppet:///modules/os_default/etc/locale.gen';

    '/etc/ssh/sshd_config':
      ensure  => file,
      source  => 'puppet:///modules/os_default/etc/ssh/sshd_config';

    '/etc/updatedb.conf':
      ensure => file,
      source => 'puppet:///modules/os_default/etc/updatedb.conf';
  }

  exec { 'locale-gen':
    command     => '/usr/bin/locale-gen',
    subscribe   => File['/etc/locale.gen'],
    refreshonly => true,
  }

  # Fix for slow drives causing hangs
  # See: http://lwn.net/Articles/572911/
  sysctl {
    'vm.dirty_background_bytes': value => '16777216';
    'vm.dirty_bytes': value => '50331648';
    # Prioritize inode/dentry cache over block cache
    'vm.vfs_cache_pressure': value => '50';
  }
}
