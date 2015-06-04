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
  include httpd
  include jenkins
  include mediaserver::manager
  include puppetmaster
  include repo

  class { 'jenkins::slave': remote => false; }

  realize Httpd::Vhost['abachi.dray.be']
}

node /^araucaria.*$/ {
  include os_default
  include httpd
  include httpd::basic
  include jenkins::slave
  include os_default::desktop
}

node 'cocobolo.dray.be' {
  include os_default
  include repo
}

node 'huon.dray.be' {
  include os_default
  include jenkins::slave
}

node 'hemlock.dray.be' {
  include os_default
  include mediaserver::downloader
}

node 'ironwood.dray.be' {
  include os_default
  include os_default::desktop
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
  include httpd
  include httpd::basic
  include os_default::desktop
}

node 'zingana.dray.be' {
  include os_default
#  include httpd::blog
  include repo
}
