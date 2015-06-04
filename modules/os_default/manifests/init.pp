class os_default {
  include monitoring
  include os_default::cron
  include os_default::misc
  include os_default::ntp
  include os_default::optimizations
  include os_default::ssh
  include os_default::sudo

  if $operatingsystem == 'Archlinux' {
    include os_default::pacman
  }

  $packages = [ 'avahi', 'cv', 'dnsutils', 'ethtool', 'git', 'haveged', 'htop', 'iftop', 'mlocate', 'mtr', 'ncdu', 'net-tools', 'nethogs', 'nss-mdns', 'pkgstats', 'rsync', 'pkgfile', 'the_silver_searcher' ]
  package { $packages: ensure => installed }

  if $architecture == 'x86_64' {
    package { [ 'aura-bin' ]:
      ensure => installed }
  }

  service {
    'avahi-daemon':
      ensure => running,
      enable => true,
      require => Package['avahi'];

    'haveged':
      ensure => running,
      enable => true,
      require => Package['haveged'];

    'puppet':
      ensure => running,
      enable => true;
  }

  file {
    '/root/.smbcreds':
      mode   => '0600',
      source => 'puppet:///modules/os_default/smbcreds';
  }

  exec { 'systemd-daemon-reload':
    command     => '/usr/bin/systemctl daemon-reload',
    refreshonly => true,
  }

}
