define btsync::folder($secret, $path = $title, $owner = 'root', $group = 'root', $sync_trash = 'true')  {
  include btsync

  $int_path = regsubst($path, '/', '')
  $clean_path = regsubst($int_path, '/', '-', 'G')
  $service_name = "${clean_path}-btsync.service"
  $config_folder = "/var/lib/btsync/custom/${clean_path}"
  $config = "${config_folder}/btsync.conf"

  exec { "${clean_path}-daemon-reload":
    command     => 'systemctl daemon-reload',
    refreshonly => true,
    notify      => Service[$service_name];
  }

  # TODO: Handle the key being changed, would require purging and recreating config directories
  file {
    "/etc/systemd/system/${service_name}":
      content => template('btsync/folder.service.erb'),
      notify  => Exec["${clean_path}-daemon-reload"];

    [ $path, $config_folder ]:
      ensure => directory,
      owner  => $owner,
      group  => $group;

    $config:
      content => template('btsync/folder.conf.erb'),
      notify  => Service[$service_name];
  }

  service { $service_name:
    ensure => running,
    enable => true,
  }

}
