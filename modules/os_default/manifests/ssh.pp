class os_default::ssh {
  package { 'openssh': ensure => installed }

  service { 'sshd':
    ensure    => running,
    enable    => true,
  }

  exec { 'sshd-moduli':
    unless => "[[ $(found=0; for i in $(cut -d' ' -f5 /etc/ssh/moduli | grep '^[0-9]'); do if [[ $i -lt 200 ]]; then found=1; fi; done; echo $found) == 0 ]]",
    command => "ssh-keygen -G /tmp/moduli -b 4096 && ssh-keygen -T /etc/ssh/moduli -f /tmp/moduli && rm /tmp/moduli",
    require => Service['haveged'],
    logoutput => true,
  }

}
