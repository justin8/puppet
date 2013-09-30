class xbmc( $user = 'xbmc', $standalone = 'true') {
  $packages = [ 'ethtool', 'git', 'polkit', 'udisks', 'xbmc-git' ]
  package { $packages: ensure => installed }

  file { '/mnt/xbmc':
    ensure => directory,
    owner  => $user,
    group  => $user,
  }

  mount { '/mnt/xbmc':
    device  => '//abachi/XBMC',
    fstype  => 'cifs',
    options => "credentials=/root/.smbcreds,noauto,x-systemd.automount,uid=$user,gid=$user",
    ensure  => mounted,
    atboot  => true,
    require => File['/mnt/xbmc'],
  }

  file { "/mnt/xbmc/$fqdn":
    ensure  => directory,
    recurse => true,
    force   => true,
    source  => 'puppet:///modules/xbmc/template',
  }

  if $user == 'xbmc' {
    file { '/var/lib/xbmc/.xbmc':
      ensure => directory,
      owner  => $user,
      group  => $user,
    }

    mount { '/var/lib/xbmc/.xbmc':
      device  => "/mnt/xbmc/$fqdn",
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
    }

    mount { "/home/$user/.xbmc":
      device  => "/mnt/xbmc/$fqdn",
      fstype  => 'none',
      options => 'bind,noauto,x-systemd.automount',
      ensure  => mounted,
      atboot  => true,
      require => Mount['/mnt/xbmc'],
    }
  }

  file { "/mnt/xbmc/$fqdn/userdata/Thumbnails":
    ensure  => '/mnt/xbmc/template/userdata/Thumbnails',
    require => File["/mnt/xbmc/$fqdn"],
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
      owner   => 'root',
      group   => 'root',
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
