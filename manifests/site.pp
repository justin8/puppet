Exec {
  path => '/usr/bin',
}

Vcsrepo {
  provider => 'git',
}

File {
  backup => false,
}

node 'abachi.dray.be' {
  include os_default
  include collectd::server
  include collectd::physical
  include httpd
  include jenkins
  include mediaserver
  include puppetmaster
  include repo
  include syncserver

  class { 'jenkins::slave': remote => false; }

  realize (
    Httpd::Vhost['abachi.dray.be'],
    Httpd::Vhost['jenkins.dray.be'],
  )
}

node /^araucaria.*$/ {
  include os_default
  include btsync::system
  include collectd::physical
  include collectd::server
  include httpd
  include httpd::basic
  include jenkins::slave
  include os_default::desktop
}

node 'huon.dray.be' {
  include os_default
  include jenkins::slave
}

node 'ironwood.dray.be' {
  include os_default
  include btsync::system
  include collectd::physical
  include os_default::desktop
}

node /^.*mediacenter.*/ {
  include os_default
  include collectd::physical
  include mediacenter
}

node 'sugi.dray.be' {
  include os_default
  include collectd::physical
  include jenkins::slave
}

node 'wkmil0393.mil.wotifgroup.com' {
  include os_default
  include collectd::physical
  include collectd::server
  include httpd
  include httpd::basic
  include syncserver
  include os_default::desktop
  class { 'repo':
    open_network => false,
  }
}

node 'zingana.dray.be' {
  include os_default
  include syncserver
#  include httpd::blog
  include repo
}
