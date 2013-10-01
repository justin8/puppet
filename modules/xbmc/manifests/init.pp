class xbmc( $user = 'xbmc', $standalone = 'true') {
  $packages = [ 'ethtool', 'polkit', 'udisks', 'xbmc-git' ]
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

  file { '/etc/polkit-1/rules.d/10-xbmc.rules':
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0664',
    source  => 'puppet:///modules/xbmc/polkit_10-xbmc.rules',
  }

  file { '/tmp/.xbmc':
    ensure  => directory,
    recurse => true,
    force   => true,
    owner   => $user,
    group   => $user,
    source  => 'puppet:///modules/xbmc/shared-settings',
  }

  file { [ "$home_path/.xbmc", "$home_path/.xbmc/userdata" ]:
    ensure  => directory,
    owner   => $user,
    group   => $user,
  }

  exec { 'settings-sync':
    command     => "/usr/bin/rsync -rlto /tmp/.xbmc/* $home_path/.xbmc/;/usr/bin/rm -rf /tmp/.xbmc",
    subscribe   => File['/tmp/.xbmc'],
    refreshonly => true,
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

    file { "$home_path/.xinitrc":
      ensure  => file,
      owner   => $user,
      group   => $user,
      source  => 'puppet:///modules/xbmc/standalone/dotfiles/.xinitrc',
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
      owner   => $user,
      group   => $user,
      source  => 'puppet:///modules/xbmc/standalone/dotfiles/.config',
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
