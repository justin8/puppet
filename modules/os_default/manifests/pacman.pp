class os_default::pacman {

  cron { 'create-package-list':
    command  => 'pacman -Q > /etc/package-list',
    user     => 'root',
    minute   => '0',
    hour     => '0',
    weekday  => '*',
    monthday => '*',
    month    => '*',
  }

  cron { 'update-pkgfile':
    command  => 'pkgfile -u &>/dev/null',
    user     => 'root',
    minute   => '0',
    hour     => '3',
    weekday  => '*',
    monthday => '*',
    month    => '*',
  }

  if $architecture == 'x86_64' {
    exec {
      'configure-repo':
        path    => '/usr/bin',
        unless  => 'pacman -Q dray-repo > /dev/null 2>&1',
        command => 'curl -s "https://repo.dray.be/dray-repo-0.7-1-any.pkg.tar.xz" > /tmp/dray-repo.pkg.tar.xz && pacman --noconfirm -U /tmp/dray-repo.pkg.tar.xz';
    }

    file { '/etc/pacman.d/mirrorlist':
      ensure => present,
      source => 'puppet:///modules/os_default/mirrorlist';
    }

    exec {
      'enable-multilib':
        path    => '/usr/bin',
        unless  => 'grep -q "^\[multilib\]" /etc/pacman.conf',
        command => 'echo -e "\n[multilib]\nInclude = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf';
    }

    $packages = [ 'nfs-utils', ]
    package { $packages: ensure => installed }

    if "$local" == "true" {
      if $::hostname != 'abachi' {
        mount { '/var/cache/pacman/pkg':
          ensure  => mounted,
          device  => "abachi.dray.be:/pacman",
          fstype  => 'nfs',
          options => 'defaults,x-systemd.automount',
          atboot  => true,
          require => Package['nfs-utils'];
        }
      }
    }
  }
}
