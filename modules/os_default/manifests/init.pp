class os_default {
  include cron
  include misc
  include ntp
  include optimizations
  include sudo

  #$packages = [ 'foo', 'bar' ]
  #packages { $packages: ensure => installed }
}
