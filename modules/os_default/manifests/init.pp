class os_default {
  include os_default::cron
  include os_default::misc
  include os_default::ntp
  include os_default::optimizations
  include os_default::sudo

  # Temporary cleanup of old facts
  file { '/etc/facter':
    ensure => absent,
  }

  #$packages = [ 'foo', 'bar' ]
  #package { $packages: ensure => installed }
}
