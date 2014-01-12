class xbmc( $user = 'xbmc', $standalone = 'true') {
  $packages = [ 'ethtool', 'polkit', 'udisks', 'xbmc-git' ]
  package { $packages: ensure => installed }
  $home = "home_$user"
  $home_path = inline_template("<%= scope.lookupvar('::$home') %>")


  file {
    '/usr/share/xbmc/addons/skin.confluence/720p/IncludesHomeMenuItems.xml':
      ensure  => file,
      mode    => '0664',
      source  => 'puppet:///modules/xbmc/IncludesHomeMenuItems.xml';

    "$home_path/.xbmc":
      ensure  => directory,
      recurse => true,
      force   => true,
      ignore  => "Thumbnails",
      owner   => $user,
      group   => $user,
      source  => 'puppet:///modules/xbmc/shared-settings';

    "$home_path/.xbmc/userdata/Thumbnails":
      ensure  => directory,
      owner   => $user,
      group   => $user,
      require => File["$home_path/.xbmc"],
  }

  mount { "$home_path/.xbmc/userdata/Thumbnails":
    device  => '//abachi/XBMC-Thumbnails',
    fstype  => 'cifs',
    options => "credentials=/root/.smbcreds,noauto,x-systemd.automount,uid=$user,gid=$user",
    ensure  => mounted,
    atboot  => true,
    require => File["$home_path/.xbmc/userdata/Thumbnails"],
  }

  # Config purely for standalone setups
  if $standalone == 'true' {
  $standalone_packages = [ 'clipit',
                           'conky',
                           'compton',
                           'evince',
                           'faenza-icon-theme',
                           'file-roller',
                           'gnome-system-monitor',
                           'gnome-themes-standard',
                           'google-chrome',
                           'gvfs',
                           'gvfs-smb',
                           'gvfs-mtp',
                           'i3-wm',
                           'i3lock',
                           'i3status',
                           'j4-dmenu-desktop',
                           'lxdm',
                           'archlinux-lxdm-theme-top',
                           'mediterraneannight-theme',
                           'nitrogen',
                           'pamixer',
                           'pasystray',
                           'pavucontrol',
                           'pulseaudio',
                           'pulseaudio-alsa',
                           'scrot',
                           'terminator',
                           'thunar',
                           'thunar-archive-plugin',
                           'thunar-media-tags-plugin',
                           'thunar-volman',
                           'ttf-dejavu',
                           'tumbler',
                           'xfce4-notifyd',
                           'xorg-server',
                           'xorg-xinit',
                           'zenity' ]
    package { $standalone_packages: ensure => installed }

    service { 'lxdm':
      ensure  => running,
      enable  => true,
      require => File['/etc/lxdm/lxdm.conf']
    }
    
    file {
      "$home_path/background.jpg":
        ensure  => file,
        owner   => $user,
        group   => $user,
        source  => 'puppet:///modules/xbmc/standalone/dotfiles/background.jpg',
        require => Package['xbmc-git'];

      "$home_path/.config":
        ensure  => directory,
        recurse => true,
        force   => true,
        ignore  => 'google-chrome',
        owner   => $user,
        group   => $user,
        source  => 'puppet:///modules/xbmc/standalone/dotfiles/.config',
        require => Package['xbmc-git'];

      "$home_path/.dmrc":
        ensure  => file,
        owner   => $user,
        group   => $user,
        source  => 'puppet:///modules/xbmc/standalone/dotfiles/.dmrc',
        require => Package['xbmc-git'];

      '/etc/lxdm/lxdm.conf':
        ensure  => file,
        source  => 'puppet:///modules/xbmc/standalone/lxdm.conf';
    }
  }
}
