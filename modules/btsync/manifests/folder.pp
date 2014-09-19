define btsync::folder($secret, $user = 'root', $group = 'root', $sync_trash = 'true')  {
  include btsync
  $clean_title = regsubst($title, '/', '-', 'G')
  $service_name = "${clean_title}-btsync.service"

  file {
    "/etc/systemd/system/${service_name}":
      content => template('btsync/folder.service.erb');

    [ $title, "/var/lib/btsync/${clean_title}" ]:
      ensure => directory
      user   => $user,
      group  => $group;

    "/var/lib/btsync/${clean_title}/btsync.conf":
      content => template('btsync/folder.conf.erb');
  }

  service { $service_name:
    ensure => running,
    enable => true,
  }

}
