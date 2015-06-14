class os_default::ssh {

  case $operatingsystem {
    'Archlinux': {
      ensure_packages(['openssh'])
      $ssh_service = 'sshd'
    }
    'Ubuntu': {
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
