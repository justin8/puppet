class sudo {
  package { 'sudo':
    ensure => installed,
  }
  file { 'sudoers':
    path    => '/etc/sudoers.d/wheel.sudo',
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0440',
    source  => 'puppet:///modules/os_default/wheel.sudo',
  }
}
