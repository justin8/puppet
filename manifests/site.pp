Exec {
  path => '/usr/bin',
}

Vcsrepo {
  provider => 'git',
}

File {
  backup => false,
}

node default {
  include os_default
  include collectd
}

node 'abachi.dray.be' inherits default {
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

node /^araucaria.*$/ inherits default {
  include btsync::system
  include collectd::physical
  include collectd::server
  include httpd
  include httpd::basic
  include jenkins::slave
  include os_default::desktop
  class { 'mediacenter':
    type  => 'xbmc',
    user  => 'jdray',
    cache => False,
  }
}

node 'huon.dray.be' inherits default {
  include jenkins::slave
}

node 'mahogany.dray.be' inherits default {
  class { 'mediacenter':
    type => 'xbmc',
    user => 'xbmc',
  }
}

node 'ironwood.dray.be' inherits default {
  include btsync::system
  include collectd::physical
  include os_default::desktop
  class { 'mediacenter':
    type => 'xbmc',
    user => 'justin',
  }
}

node /xbmc/ inherits default {
  include collectd::physical
  class { 'mediacenter':
    type => 'xbmc-standalone',
    user => 'htpc',
  }
}

node 'sugi.dray.be' inherits default {
  include collectd::physical
  include jenkins::slave
}

node 'wkmil0393.mil.wotifgroup.com' inherits default {
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

node 'zingana.dray.be' inherits default {
  include syncserver
  include httpd::blog
  include repo
}
