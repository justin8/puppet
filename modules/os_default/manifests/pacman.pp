class os_default::pacman {

  $packages = [ 'cifs-utils', 'smbclient' ]
  package { $packages: ensure => installed }

  if "$local" == "true" {
    if "$hostname" != "abachi" {
      mount { "/var/cache/pacman/pkg":
        device  => "//abachi.dray.be/pacman-pkg-$architecture",
        fstype  => 'cifs',
        options => "credentials=/root/.smbcreds,noauto,x-systemd.automount",
        ensure  => mounted,
        atboot  => true;
      }
    }
  }
}
