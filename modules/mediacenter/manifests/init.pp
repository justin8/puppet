class mediacenter( $user='htpc' ) {

  if $user == 'htpc' {
    $home_path = "/home/${user}"
  } else {
    $home = "home_${user}"
    $home_path = inline_template("<%= scope.lookupvar('::${home}') %>")
  }

  user { $user:
    home       => $home_path,
    groups     => 'wheel',
    managehome => true,
  }

  ensure_packages([
    'clipit',
    'evince',
    'faenza-icon-theme',
    'file-roller',
    'chromium',
    'chromium-pepper-flash',
    'gdm',
    'gnome',
    'gnome-shell-extensions',
    'gvfs',
    'gvfs-smb',
    'gvfs-mtp',
    'plex-home-theater',
    'pulseaudio',
    'pulseaudio-alsa',
    'scrot',
    'terminator',
    'thunar',
    'thunar-archive-plugin',
    'thunar-media-tags-plugin',
    'thunar-volman',
    'ttf-dejavu',
    'xorg-server',
    'xorg-xinit',
    'zenity',
    ])

  service {
    'bluetooth':
      ensure  => running,
      enable  => true;

    'gdm':
      ensure  => running,
      enable  => true,
      require => [ File['/etc/gdm/custom.conf'], File["${home_path}/.config"] ];
  }

  file {
    "${home_path}/.config":
      ensure  => directory,
      recurse => true,
      force   => true,
      ignore  => 'chromium',
      owner   => $user,
      group   => $user,
      source  => 'puppet:///modules/mediacenter/dotfiles/.config',
      require => User[$user];

    "${home_path}/.config/autostart/misc-settings.desktop":
      ensure  => file,
      mode    => '0755',
      owner   => $user,
      group   => $user,
      content => template('mediacenter/misc-settings.desktop.erb');

    '/etc/gdm/custom.conf':
      ensure  => file,
      require => Package['gdm'],
      content => template('mediacenter/custom.conf.erb');
  }

}
