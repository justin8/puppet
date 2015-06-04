class os_default::ssh {
  package { 'openssh': ensure => installed }

  service { 'sshd':
    ensure    => running,
    enable    => true,
  }

}
