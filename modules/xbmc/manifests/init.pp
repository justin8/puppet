class xbmc( $user = 'xbmc', $standalone = 'true') {
  $packages = [ 'ethtool', 'pasystray-git', 'polkit', 'udisks', 'xbmc-git' ]
  package { $packages: ensure => installed }
  $home = "home_$user"
  $home_path = inline_template("<%= scope.lookupvar('::$home') %>")

  file { '/usr/share/xbmc/addons/skin.confluence/720p/IncludesHomeMenuItems.xml':
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0664',
    source  => 'puppet:///modules/xbmc/IncludesHomeMenuItems.xml',
  }

  file { "$home_path/.xbmc":
    ensure  => directory,
    recurse => true,
    force   => true,
    ignore  => "Thumbnails",
    owner   => $user,
    group   => $user,
    source  => 'puppet:///modules/xbmc/shared-settings',
  }

  file { "$home_path/.xbmc/userdata/Thumbnails":
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
    $standalone_packages = [ 'lxdm', 'archlinux-lxdm-theme-top' ]
    package { $standalone_packages: ensure => installed }

# Remove later
    package { 'slim':
      ensure  => 'absent',
      require => Service['slim'];
    }

    service { 'slim':
      ensure  => stopped,
      enable  => false,
    }

    file { "$home_path/.xinitrc":
      ensure  => absent,
    }

# End remove

    service { 'lxdm':
      ensure  => running,
      enable  => true,
      require => File['/etc/lxdm/lxdm.conf']
    }
    
    file { "$home_path/background.jpg":
      ensure  => file,
      owner   => $user,
      group   => $user,
      source  => 'puppet:///modules/xbmc/standalone/dotfiles/background.jpg',
    }

    file { "$home_path/.config":
      ensure  => directory,
      recurse => true,
      force   => true,
      ignore  => 'google-chrome',
      owner   => $user,
      group   => $user,
      source  => 'puppet:///modules/xbmc/standalone/dotfiles/.config',
    }

    file { '/etc/lxdm/lxdm.conf':
      ensure  => file,
      source  => 'puppet:///modules/xbmc/standalone/lxdm.conf',
    }
  }
}
