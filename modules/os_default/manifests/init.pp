class os_default {
  include cron
  include ntp
  include optimizations
  include sudo

  file { '/etc/udev/rules.d/50-wol.rules':
    ensure => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0664',
    source  => 'puppet:///modules/os_default/udev_50-wol.rules',
  }
}
