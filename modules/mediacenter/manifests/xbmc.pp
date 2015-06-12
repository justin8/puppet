class mediacenter::xbmc( $user, $cache, $home_path ) {
  ensure_packages(['polkit', 'udisks', 'xbmc'])

  file {
    '/usr/share/xbmc/addons/skin.confluence/720p/IncludesHomeMenuItems.xml':
      ensure  => file,
      mode    => '0644',
      require => Package['xbmc'],
      source  => 'puppet:///modules/mediacenter/xbmc/common/IncludesHomeMenuItems.xml';

    "${home_path}/.xbmc":
      ensure => directory,
      owner  => $user,
      group  => $user;

    "${home_path}/.xbmc/userdata":
      ensure  => directory,
      recurse => true,
      force   => true,
      ignore  => 'Thumbnails',
      owner   => $user,
      group   => $user,
      require => Package['xbmc'],
      source  => 'puppet:///modules/mediacenter/xbmc/common/userdata';

    "${home_path}/.xbmc/userdata/Thumbnails":
      ensure  => directory,
      owner   => $user,
      group   => $user,
      require => File["${home_path}/.xbmc/userdata"],
  }

  if $cache == True {
    mount { "${home_path}/.xbmc/userdata/Thumbnails":
      ensure  => mounted,
      device  => '//abachi/XBMC-Thumbnails',
      fstype  => 'cifs',
      options => "credentials=/root/.smbcreds,noauto,x-systemd.automount,uid=${user},gid=${user}",
      atboot  => true,
      require => File["${home_path}/.xbmc/userdata/Thumbnails"],
    }
  } else {
    mount { "${home_path}/.xbmc/userdata/Thumbnails":
      ensure => absent,
    }
  }

  mediacenter::xbmc::gui {
    'skin.confluence.HomeMenuNoWeatherButton': value => 'true', user => $user;
    'skin.confluence.HomeMenuNoPicturesButton': value => 'true', user => $user;
    'skin.confluence.HomeMenuNoMovieButton': value => 'true', user => $user;
    'skin.confluence.HomeMenuNoTVShowButton': value => 'true', user => $user;
    'skin.confluence.HomeMenuNoProgramsButton': value => 'true', user => $user;
    'country': value => 'Australia \(12h\)', user => $user;
    'timezone': value => 'Australia\/Brisbane', user => $user;
    'timezonecountry': value => 'Australia', user => $user;
  }

}
