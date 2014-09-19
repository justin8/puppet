define btsync::folder($secret, $path = $title, $owner = 'root', $group = 'root', $sync_trash = 'true')  {
  include btsync

  $int_path = regsubst($path, '/', '')
  $clean_path = regsubst($int_path, '/', '-', 'G')
  $service_name = "${clean_path}-btsync.service"
  $config_folder = "/var/lib/btsync/${clean_path}"
  $config = "${config_folder}/btsync.conf"

  file {
    "/etc/systemd/system/${service_name}":
      content => template('btsync/folder.service.erb');

    [ $path, $config_folder ]:
      ensure => directory,
      owner  => $owner,
      group  => $group;

    $config:
      content => template('btsync/folder.conf.erb');
  }

  service { $service_name:
    ensure => running,
    enable => true,
  }

}
