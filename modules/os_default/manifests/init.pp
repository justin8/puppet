class os_default {
  include os_default::cron
  include os_default::misc
  include os_default::ntp
  include os_default::optimizations
  include os_default::pacman
  include os_default::ssh
  include os_default::sudo

  $packages = [ 'aura-bin', 'dnsutils', 'git', 'htop', 'iftop', 'mlocate', 'mtr', 'ncdu', 'nethogs', 'rsync', 'pkgfile' ]
  package { $packages: ensure => installed }

  service { 'puppet':
    ensure => running,
    enable => true,
  }

  file {
    '/root/.smbcreds':
      mode   => '0600',
      source => 'puppet:///modules/os_default/smbcreds';
  }

}
