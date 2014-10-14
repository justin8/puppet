class mediacenter::standalone( $type, $user, $home_path ) {
  user { $user:
    home       => $home_path,
    groups     => 'wheel',
    managehome => true,
  }

  if $type == 'xbmc' {
    file { "${home_path}/.config/autostart/xbmc.desktop":
      ensure => link,
      target => '/usr/share/applications/xbmc.desktop',
    }
#  } elsif $type == 'plex' {
  }

  $standalone_packages = [
    'adwaita-x-dark-and-light-theme',
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
    'zenity' ]
  package { $standalone_packages: ensure => installed }

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
    [
      "${home_path}/.config",
      "${home_path}/.config/autostart",
    ] :
      ensure => directory,
      owner  => $user,
      group  => $user;

    "${home_path}/.background.jpg":
      ensure  => file,
      source  => 'puppet:///modules/mediacenter/standalone/dotfiles/background.jpg',
      require => User[$user];

    "${home_path}/.config":
      ensure  => directory,
      recurse => true,
      force   => true,
      ignore  => 'chromium',
      owner   => $user,
      group   => $user,
      source  => 'puppet:///modules/mediacenter/standalone/dotfiles/.config',
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