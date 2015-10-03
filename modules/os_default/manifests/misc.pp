class os_default::misc {
  file {
    '/usr/local/bin/snap':
      ensure  => file,
      mode    => '0775',
      source  => 'puppet:///modules/os_default/snap';

    '/etc/locale.gen':
      ensure  => file,
      source  => 'puppet:///modules/os_default/etc/locale.gen';

    '/etc':
      ensure  => directory,
      recurse => 'remote',
      source  => 'puppet:///modules/os_default/etc';
  }

  exec { 'locale-gen':
    path        => '/usr/bin',
    command     => '/usr/bin/locale-gen',
    subscribe   => File['/etc/locale.gen'],
    refreshonly => true,
  }
}
