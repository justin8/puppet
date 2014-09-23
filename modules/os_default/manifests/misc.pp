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

    '/etc/locale.gen':
      ensure  => file;

    '/etc':
      ensure  => directory,
      recurse => 'remote',
      source  => 'puppet:///modules/os_default/etc';
  }

  exec { 'locale-gen':
    command     => '/usr/bin/locale-gen',
    subscribe   => File['/etc/locale.gen'],
    refreshonly => true,
  }
}
