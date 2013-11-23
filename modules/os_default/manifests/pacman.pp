class os_default::pacman {

  if str2bool("$local") {
    mount { "/var/cache/pacman/pkg":
      device  => "//abachi.dray.be/pacman-pkg-$architecture",
      fstype  => 'cifs',
      options => "credentials=/root/.smbcreds,noauto,x-systemd.automount",
      ensure  => mounted,
      atboot  => true;
  }
}
