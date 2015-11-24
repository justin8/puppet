class os_default::ssh {

  case $osfamily {
    'Archlinux': {
      ensure_packages(['openssh'])
      $ssh_service = 'sshd'
    }
    'Debian': {
      ensure_packages(['openssh-server'])
      $ssh_service = 'ssh'
    }
    default: { fail('Unsupported OS') }
  }

  service { $ssh_service:
    ensure    => running,
    enable    => true,
  }

}
