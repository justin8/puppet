class os_default::pacman {

  $packages = [ 'cifs-utils', 'smbclient' ]
  package { $packages: ensure => installed }

  file { '/etc/pacman.d/mirrorlist':
    ensure => present,
    source => 'puppet:///modules/os_default/etc/pacman.d/mirrorlist';
  }

  exec {
    'configure-repo':
      path    => '/usr/bin',
      unless  => 'pacman -Q dray-repo > /dev/null 2>&1',
      command => 'curl -s "https://repo.dray.be/any/dray-repo-0.7-1-any.pkg.tar.xz" > /tmp/dray-repo.pkg.tar.xz && pacman --noconfirm -U /tmp/dray-repo.pkg.tar.xz';
  }

  if $::architecture == 'x86_64' {
    exec {
      'enable-multilib':
        path    => '/usr/bin',
        unless  => 'grep -q "^\[multilib\]" /etc/pacman.conf',
        command => 'echo -e "\n[multilib]\nInclude = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf';
    }
  }

  if "$local" == "true" {
    if $::hostname != 'abachi' {
      mount { '/var/cache/pacman/pkg':
        ensure  => mounted,
        device  => "//abachi/pacman-pkg-${::architecture}",
        fstype  => 'cifs',
        options => 'credentials=/root/.smbcreds,noauto,x-systemd.automount',
        atboot  => true;
      }
    }
  }
}
