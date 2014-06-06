class xbmc::standalone($user = 'xbmc') {
  $home = "home_${user}"
  $home_path = inline_template("<%= scope.lookupvar('${::home}') %>")
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

  user { $user:
    shell   => '/usr/bin/zsh',
    groups  => 'users',
    require => Package['xbmc']
  }

  service {
    'gdm':
      ensure  => running,
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
      require => User[$user];

    "${home_path}/.config":
      ensure  => directory,
      recurse => true,
      force   => true,
      ignore  => 'chromium',
      owner   => $user,
      group   => $user,
      source  => 'puppet:///modules/xbmc/standalone/dotfiles/.config',
      require => User[$user];

    '/etc/gdm/custom.conf':
      ensure  => file,
      require => Package['gdm'],
      source  => 'puppet:///modules/xbmc/standalone/gdm-custom.conf';
  }
}
