class xbmc::standalone($user = 'xbmc') {
  class { 'xbmc':
    user => $user,
  }

  $standalone_packages = [
    'adwaita-x-dark-and-light-theme',
    'clipit',
    'evince',
    'faenza-icon-theme',
    'file-roller',
    'chromium',
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

  package { [ 'slim', 'lxdm' ]:
    ensure => absent
  }

  service {
    'gdm':
      ensure  => started,
      enable  => true,
      require => File['/etc/gdm/custom.conf'];

    'lxdm':
      ensure => stopped,
      enable => false,
      notify => Service['gdm'];

    'slim':
      ensure => stopped,
      enable => false,
      notify => Service['gdm'];
  }

  file {
    "${home_path}/background.jpg":
      ensure  => file,
      owner   => $user,
      group   => $user,
      source  => 'puppet:///modules/xbmc/standalone/dotfiles/background.jpg',
      require => Package['xbmc'];

    "${home_path}/.config":
      ensure  => directory,
      recurse => true,
      force   => true,
      ignore  => 'chromium',
      owner   => $user,
      group   => $user,
      source  => 'puppet:///modules/xbmc/standalone/dotfiles/.config',
      require => Package['xbmc'];

    '/etc/gdm/custom.conf':
      ensure  => file,
      require => Package['gdm'],
      source  => 'puppet:///modules/xbmc/standalone/gdm-custom.conf';
  }

  dconf::set {
    '/org/gnome/desktop/session/idle-delay':
      value => 0,
      user  => $user,
      group => $user;

    '/org/gnome/desktop/wm/preferences/theme':
      value => "'Adwaita-X-dark'",
      user  => $user,
      group => $user;

    '/org/gnome/desktop/interface/gtk-theme':
      value => "'Adwaita'",
      user  => $user,
      group => $user;

    '/org/gnome/desktop/interface/icon-theme':
      value => "'Faenza'",
      user  => $user,
      group => $user;

    '/org/gnome/settings-daemon/plugins/power/sleep-inactive-ac-type':
      value => "'nothing'",
      user  => $user,
      group => $user;
}
