class facter {
  package { 'ruby-facter': ensure => installed }

  file { '/etc/facter' :
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0775',
  }

  file { '/etc/facter/facts.d':
    ensure  => directory,
    recurse => true,
    owner   => 'root',
    group   => 'root',
    mode    => '0775',
    source  => 'puppet:///modules/os_default/facts.d',
    require => File['/etc/facter'],
  }
}
