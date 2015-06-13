class os_default::os_specifics::archlinux {

  ensure_packages(['dnsutils', 'pkgfile', 'pkgstats'])

  if $architecture == 'x86_64' { ensure_packages(['aura-bin']) }

  # Package manager config

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
        command => 'curl -s "https://repo.dray.be/dray-repo-latest" > /tmp/dray-repo.pkg.tar.xz && pacman --noconfirm -U /tmp/dray-repo.pkg.tar.xz';
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

    # Package cache
    ensure_packages(['nfs-utils'])

    if "$local" == "true" {
      if $::hostname != 'abachi' {
        mount { '/var/cache/pacman/pkg':
          ensure  => mounted,
          device  => "abachi.local:/pacman",
          fstype  => 'nfs',
          options => 'defaults,noauto,x-systemd.automount',
          atboot  => true,
          require => Package['nfs-utils'];
        }
      }
    }
  }
}
