class repo::mount( $remote = true, $user = root ) {

  if $remote {

    file {
      '/srv/repo':
      ensure => directory;
    }

    mount {
      "/srv/repo":
        device  => "//abachi.dray.be/repo",
        fstype  => 'cifs',
        options => "credentials=/root/.smbcreds,noauto,x-systemd.automount,uid=$user,gid=$user",
        ensure  => mounted,
        atboot  => true,
        require => File['/srv/repo'];
    }
  } else {
    file {
      '/srv/repo':
        ensure => link,
        target => '/raid/server-files/system/srv/repo/';
    }
  }
}
