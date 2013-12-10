class repo::mount( $remote = true, $user ) {

  if $remote {

    file {
      '/srv/repo':
      ensure => directory;
    }

    if $user {
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
      mount {
        "/srv/repo":
          device  => "//abachi.dray.be/repo",
          fstype  => 'cifs',
          options => "credentials=/root/.smbcreds,noauto,x-systemd.automount",
          ensure  => mounted,
          atboot  => true,
          require => File['/srv/repo'];
      }
    }
  } else {
    file {
      '/srv/repo':
        ensure => link,
        target => '/raid/server-files/system/srv/repo/';
    }
  }
}
