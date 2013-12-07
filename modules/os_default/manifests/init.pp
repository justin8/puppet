class os_default {
  include os_default::cron
  include os_default::misc
  include os_default::ntp
  include os_default::optimizations
  include os_default::pacman
  include os_default::sudo

  $packages = [ 'pkgfile' ]
  package { $packages: ensure => installed }
}
