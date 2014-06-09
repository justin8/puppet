class xbmc::standalone($user = 'htpc') {
  if $user == 'htpc' {
    $home_path = "/home/${user}"

    user { $user:
      home   => $home_path,
      groups => 'wheel',
    }

    file { $home_path:
      ensure => directory,
      owner  => $user,
      group  => $user;
    }
  } else {
    $home = "home_${user}"
    $home_path = inline_template("<%= scope.lookupvar('::${home}') %>")
  }

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

# TODO: cleanup later
  package { [ 'slim', 'lxdm' ]:
    ensure => absent
  }

# TODO: cleanup later
  service {
    'bluetooth':
      ensure  => running,
      enable  => true;

    'gdm':
      ensure  => running,
      enable  => true,
      require => [ File['/etc/gdm/custom.conf'], File["${home_path}/.config"] ];

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
    "${home_path}/.background.jpg":
      ensure  => file,
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

    "${home_path}/.config/autostart/dconf-settings.desktop":
      ensure  => file,
      mode    => '0755',
      owner   => $user,
      group   => $user,
      content => template('xbmc/dconf-settings.desktop.erb');

    '/etc/gdm/custom.conf':
      ensure  => file,
      require => Package['gdm'],
      content => template('xbmc/custom.conf.erb');
  }
}
