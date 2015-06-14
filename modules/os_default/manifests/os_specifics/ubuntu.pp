class os_default::os_specifics::ubuntu {
  if versioncmp($operatingsystemmajrelease, '15.04') >= 0 { Service { provider => 'systemd' } }

  ensure_packages(['dnsutils', 'libnss-mdns', 'silversearcher-ag'])
  package { 'avahi-daemon': before => Service['avahi-daemon'] }
  package { 'nscd': before => Service['nscd'] }

}
