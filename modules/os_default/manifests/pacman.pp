class os_default::pacman {

  $packages = [ 'cifs-utils', 'smbclient' ]
  package { $packages: ensure => installed }

  exec { 'configure-repo':
    path    => '/usr/bin',
    unless  => 'pacman -Q dray-repo > /dev/null 2>&1',
    command => 'curl -s "https://repo.dray.be/any/dray-repo-0.5-1-any.pkg.tar.xz" > /tmp/dray-repo.pkg.tar.xz \
                && pacman --noconfirm -U /tmp/dray-repo.pkg.tar.xz';
  }

  if "$local" == "true" {
    if "$hostname" != "abachi" {
      mount { "/var/cache/pacman/pkg":
        device  => "//abachi/pacman-pkg-$architecture",
        fstype  => 'cifs',
        options => "credentials=/root/.smbcreds,noauto,x-systemd.automount",
        ensure  => mounted,
        atboot  => true;
      }
    }
  }
}
