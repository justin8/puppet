class sudo {
  package { 'sudo': ensure => installed }
  file { '/etc/sudoers.d/wheel':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0440',
    source  => 'puppet:///modules/os_default/wheel.sudo',
  }
}
