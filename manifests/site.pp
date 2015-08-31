Exec {
  path => $::path,
}

Vcsrepo {
  provider => 'git',
}

File {
  backup => false,
}

node 'default' {
  include os_default
}

node 'abachi.dray.be' {
  include os_default
  include monitoring::server
  include jenkins::master
  include jenkins::slave
  include mediaserver::manager
  include puppetmaster
  include repo

  class { 'btsync::system':
    user  => 'downloads',
    group => 'downloads',
  }

  vhost { 'abachi':
    url       => 'abachi.dray.be',
    www_root  => '/srv/http',
    autoindex => 'on',
    auth_basic_user_file => '/srv/htpasswd',
  }

  vhost { 'public':
    url      => 'public.dray.be',
    www_root => '/srv/public',
    sync     => true,
  }
}

node 'hemlock.dray.be' {
  include os_default
  include mediaserver::downloader
}

node 'ironwood.dray.be' {
  include os_default
  include os_default::desktop
}

node /^cypress.*/ {
  include os_default
  include openvpn
  include repo
}

node /^.*mediacenter.*/ {
  include os_default
  include mediacenter
}

node /^dalemc.*/ {
  include os_default
  include openvpn
}

node 'wkmil0393.mil.wotifgroup.com' {
  include os_default
  include os_default::desktop
}
