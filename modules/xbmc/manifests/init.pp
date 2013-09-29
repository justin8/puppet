class xbmc( $user = 'xbmc', $standalone = 'true') {
  $packages = [ 'ethtool', 'git', 'polkit', 'udisks', 'xbmc-git' ]
  package { $packages: ensure => installed }

  file { '/mnt/xbmctest':
    ensure => directory,
    owner  => $user,
    group  => $user,
    mode   => '0775',
  }

  mount { '/mnt/xbmctest':
    device  => '//abachi/XBMC',
    fstype  => 'cifs',
    options => "credentials=/root/.smbcreds,noauto,x-systemd.automount,uid=$user,gid=$user",
    ensure  => mounted,
    atboot  => true,
    require => File['/mnt/xbmctest'],
  }

  file { "/mnt/xbmctest/settings/$fqdn":
    ensure  => directory,
    owner   => $user,
    group   => $user,
    mode    => '0775',
    require => Mount['/mnt/xbmctest'],
  }

  file { "/mnt/xbmctest/settings/$fqdn/userdata":
    ensure  => directory,
    owner   => $user,
    group   => $user,
    mode    => '0775',
    require => File["/mnt/xbmctest/settings/$fqdn"],
  }

  if $user == 'xbmc' {
    file { '/var/lib/xbmc/.xbmc':
      ensure => directory,
      owner  => $user,
      group  => $user,
      mode   => '0775'
    }

    mount { '/var/lib/xbmc/.xbmc':
      device  => "/mnt/xbmctest/settings/$fqdn",
      fstype  => 'none',
      options => 'bind,noauto,x-systemd.automount',
      ensure  => mounted,
      atboot  => true,
      require => Mount['/mnt/xbmctest'],
    }
  }
  else {
    file { "/home/$user/.xbmc":
      ensure => directory,
      owner  => $user,
      group  => $user,
      mode   => '0775'
    }

    mount { "/home/$user/.xbmc":
      device  => "/mnt/xbmctest/settings/$fqdn",
      fstype  => 'none',
      options => 'bind,noauto,x-systemd.automount',
      ensure  => mounted,
      atboot  => true,
      require => Mount['/mnt/xbmctest'],
    }
  }

  file { "/mnt/xbmctest/settings/$fqdn/userdata/advancedsettings.xml":
    ensure  => link,
    target  => '/mnt/xbmctest/template/userdata/advancedsettings.xml',
    require => File["/mnt/xbmctest/settings/$fqdn/userdata"],
  }

  file { "/mnt/xbmctest/settings/$fqdn/userdata/Thumbnails":
    ensure  => link,
    target  => '/mnt/xbmctest/template/userdata/Thumbnails',
    require => File["/mnt/xbmctest/settings/$fqdn/userdata"],
  }

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

  # Config purely for standalone setups
  if $standalone == 'true' {
    $standalone_packages = [ 'slim' ]
    package { $standalone_packages: ensure => installed }

    service { 'slim':
      ensure  => running,
      enable  => true,
      require => [ File['/var/lib/xbmc'],
                   File['/etc/slim.conf'] ],
    }
    
    file { "/usr/local/bin/xbmc-wrapper":
      ensure  => file,
      owner   => root,
      group   => root,
      mode    => '0775',
      source  => 'puppet:///modules/xbmc/xbmc-wrapper',
    }

    file { '/var/lib/xbmc':
      ensure  => directory,
      recurse => true,
      owner   => $user,
      group   => $user,
      source  => 'puppet:///modules/xbmc/dotfiles',
    }

    file { '/etc/slim.conf':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0664',
      source  => 'puppet:///modules/xbmc/slim.conf',
    }

    file { '/etc/udev/rules.d/50-wol.rules':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0664',
      source  => 'puppet:///modules/xbmc/udev_50-wol.rules',
    }
  }
}
