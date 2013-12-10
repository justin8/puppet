class repo::mount( remote = true ) {

  if $remote {

    file {
      '/srv/repo':
      ensure => directory;
    }

    mount {
      "/srv/repo":
        device  => "//abachi.dray.be/repo",
        fstype  => 'cifs',
        options => "credentials=/root/.smbcreds,noauto,x-systemd.automount",
        ensure  => mounted,
        atboot  => true;
    }
  } else {
    file {
      '/srv/repo':
        ensure => link,
        target => '/raid/server-files/system/srv/repo/';
    }
  }
}
