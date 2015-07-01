Exec {
  path => '/usr/bin',
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

  vhost { 'abachi':
    url       => 'abachi.dray.be',
    www_root  => '/srv/http',
    autoindex => 'on',
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

node 'cypress.dray.be' {
  include os_default
  include openvpn
}

node /^.*mediacenter.*/ {
  include os_default
  include mediacenter
}

node 'sugi.dray.be' {
  include os_default
  include jenkins::slave
}

node 'wkmil0393.mil.wotifgroup.com' {
  include os_default
  include os_default::desktop
}

node 'zingana.dray.be' {
  include os_default
  include repo
}
