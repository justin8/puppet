class os_default::os_specifics {
  case $operatingsystem {
    'Archlinux': { include os_default::os_specifics::archlinux }
    'Fedora': { include os_default::os_specifics::fedora }
  }
}
