class os_default::os_specifics::debian {

  ensure_packages(['dnsutils', 'libnss-mdns', 'silversearcher-ag'])
  package { 'avahi-daemon': before => Service['avahi-daemon'] }
  package { 'nscd': before => Service['nscd'] }

  exec { 'append local domain':
    command => 'printf "\n\nsearch local dray.be\n" >> /etc/resolvconf/resolv.conf.d/head; resolvconf -u',
    unless  => 'grep -q "search" /etc/resolvconf/resolv.conf.d/head',
  }

}
