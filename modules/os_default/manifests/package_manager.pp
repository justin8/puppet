class os_default::package_manager {
  case $operatingsystem {
    'Archlinux': { include os_default::package_manager::pacman }
  }
}
