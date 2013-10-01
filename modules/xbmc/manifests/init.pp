class xbmc( $user = 'xbmc', $standalone = 'true') {
  $packages = [ 'ethtool', 'polkit', 'udisks', 'xbmc-git' ]
  package { $packages: ensure => installed }

  file { '/usr/share/xbmc/addons/skin.confluence/720p/IncludesHomeMenuItems.xml':
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0664',
    source  => 'puppet:///modules/xbmc/IncludesHomeMenuItems.xml',
  }

  file { '/etc/polkit-1/rules.d/10-xbmc.rules':
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0664',
    source  => 'puppet:///modules/xbmc/polkit_10-xbmc.rules',
  }

  if $user == 'xbmc' {
    file { '/var/lib/xbmc/.xbmc':
      ensure  => directory,
      recurse => true,
      force   => true,
      owner   => $user,
      group   => $user,
      source  => 'puppet:///modules/xbmc/shared-settings',
    }

    file { '/var/lib/xbmc/.xbmc/userdata/Thumbnails':
      ensure  => directory,
      owner   => $user,
      group   => $user,
      require => File['/var/lib/xbmc/.xbmc'],
    }

    mount { '/var/lib/xbmc/.xbmc/userdata/Thumbnails':
      device  => '//abachi/XBMC-Thumbnails',
      fstype  => 'cifs',
      options => 'credentials=/root/.smbcreds,noauto,x-systemd.automount,uid=$user,gid=$user',
      ensure  => mounted,
      atboot  => true,
      require => File['/var/lib/xbmc/.xbmc/userdata/Thumbnails"],
    }
  }
  else {
    file { "/home/$user/.xbmc":
      ensure   => directory,
      recurse  => true,
      force    => true,
      owner    => $user,
      group    => $user,
      source   => "puppet:///modules/xbmc/shared-settings",
    }

    file { "/home/$user/.xbmc/userdata/Thumbnails":
      ensure  => directory,
      owner   => $user,
      group   => $user,
      require => File["/home/$user/.xbmc"],
    }

    mount { "/home/$user/.xbmc/userdata/Thumbnails":
      device  => '//abachi/XBMC-Thumbnails',
      fstype  => 'cifs',
      options => 'credentials=/root/.smbcreds,noauto,x-systemd.automount,uid=$user,gid=$user',
      ensure  => mounted,
      atboot  => true,
      require => File["/home/$user/.xbmc/userdata/Thumbnails"],
    }
  }

  # Config purely for standalone setups
  if $standalone == 'true' {
    $standalone_packages = [ 'slim' ]
    package { $standalone_packages: ensure => installed }

    service { 'slim':
      ensure  => running,
      enable  => true,
      require => File['/etc/slim.conf']
    }
    
    file { "/usr/local/bin/xbmc-wrapper":
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0775',
      source  => 'puppet:///modules/xbmc/standalone/xbmc-wrapper',
    }

    file { '/var/lib/xbmc':
      ensure  => directory,
      recurse => true,
      owner   => $user,
      group   => $user,
      source  => 'puppet:///modules/xbmc/standalone/dotfiles',
    }

    file { '/etc/slim.conf':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0664',
      source  => 'puppet:///modules/xbmc/standalone/slim.conf',
    }
  }
}
