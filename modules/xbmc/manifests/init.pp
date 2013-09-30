class xbmc( $user = 'xbmc', $standalone = 'true') {
  $packages = [ 'ethtool', 'git', 'polkit', 'udisks', 'xbmc-git' ]
  package { $packages: ensure => installed }

  file { '/mnt/xbmc':
    ensure => directory,
    owner  => $user,
    group  => $user,
    mode   => '0775',
  }

  mount { '/mnt/xbmc':
    device  => '//abachi/XBMC',
    fstype  => 'cifs',
    options => "credentials=/root/.smbcreds,noauto,x-systemd.automount,uid=$user,gid=$user",
    ensure  => mounted,
    atboot  => true,
    require => File['/mnt/xbmc'],
  }

#  file { "/mnt/xbmc/settings/$fqdn":
#    ensure  => directory,
#    owner   => $user,
#    group   => $user,
#    mode    => '0775',
#    require => Mount['/mnt/xbmc'],
#  }

  exec { "/mnt/xbmc/settings/$fqdn":
    command => "/bin/mkdir -p /mnt/xbmc/settings/$fqdn;rsync -rltv --exclude='Thumbnails' /mnt/xbmc/template/* /mnt/xbmc/settings/$fqdn",
    creates => "/mnt/xbmc/settings/$fqdn",
  }

  file { "/mnt/xbmc/settings/$fqdn/userdata":
    ensure  => directory,
    owner   => $user,
    group   => $user,
    mode    => '0775',
    require => Exec["/mnt/xbmc/settings/$fqdn"],
  }

  if $user == 'xbmc' {
    file { '/var/lib/xbmc/.xbmc':
      ensure => directory,
      owner  => $user,
      group  => $user,
      mode   => '0775'
    }

    mount { '/var/lib/xbmc/.xbmc':
      device  => "/mnt/xbmc/settings/$fqdn",
      fstype  => 'none',
      options => 'bind,noauto,x-systemd.automount',
      ensure  => mounted,
      atboot  => true,
      require => Mount['/mnt/xbmc'],
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
      device  => "/mnt/xbmc/settings/$fqdn",
      fstype  => 'none',
      options => 'bind,noauto,x-systemd.automount',
      ensure  => mounted,
      atboot  => true,
      require => Mount['/mnt/xbmc'],
    }
  }

  file { "/mnt/xbmc/settings/$fqdn/userdata/advancedsettings.xml":
    ensure  => link,
    target  => '/mnt/xbmc/template/userdata/advancedsettings.xml',
    require => File["/mnt/xbmc/settings/$fqdn/userdata"],
  }

  file { "/mnt/xbmc/settings/$fqdn/userdata/Thumbnails":
    ensure  => link,
    target  => '/mnt/xbmc/template/userdata/Thumbnails',
    require => File["/mnt/xbmc/settings/$fqdn/userdata"],
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
  }
}
