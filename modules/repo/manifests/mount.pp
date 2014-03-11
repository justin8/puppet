class repo::mount( $remote = true, $user = root ) {

  if $remote {

    file {
      '/srv/repo':
      ensure => directory;
    }

    mount {
      '/srv/repo':
        ensure  => mounted,
        device  => '//abachi.dray.be/repo',
        fstype  => 'cifs',
        options =>
"credentials=/root/.smbcreds,noauto,x-systemd.automount,uid=${user},gid=${user}",
        atboot  => true,
        require => File['/srv/repo'];
    }
  }
}
