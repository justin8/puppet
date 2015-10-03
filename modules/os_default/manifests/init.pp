class os_default {
  include ::ntp
  include ::monitoring
  include os_default::cron
  include os_default::misc
  include os_default::optimizations
  include os_default::os_specifics
  include os_default::ssh
  include os_default::sudo
  include systemd

  ensure_packages(['ethtool', 'git', 'haveged', 'htop', 'iftop', 'iotop', 'mlocate', 'mtr', 'ncdu', 'net-tools', 'nethogs', 'rsync'])

  service {
    'avahi-daemon':
      ensure => running,
      enable => true;

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

  if kernelrelease =~ /grsec/ {
    sysctl { 'kernel.grsecurity.enforce_symlinksifowner':
      value => '0';
    }
  }
}
