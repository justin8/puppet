class os_default::ssh {
  ensure_packages(['openssh'])

  service { 'sshd':
    ensure    => running,
    enable    => true,
  }

}
