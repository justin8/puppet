class os_default::os_specifics {
  case $osfamily {
    'Archlinux': { include os_default::os_specifics::archlinux }
    'Fedora': { include os_default::os_specifics::fedora }
    'Debian': { include os_default::os_specifics::debian }
    default: { fail('Unsupported OS') }
  }
}
