class os_default::os_specifics::fedora {
  if $operatingsystem == 'Fedora' { Service { provider => 'systemd' } }

  case $operatingsystemmajrelease {
    '22': {
      package { 'rpm-fusion-free':
        provider => rpm,
        source   => 'http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-22.noarch.rpm',
      }
    }
  }

  ensure_packages(['bind-utils', 'nss-mdns', 'the_silver_searcher'])
  package { 'avahi': before => Service['avahi-daemon'] }
  package { 'nscd': before => Service['nscd'] }
}
