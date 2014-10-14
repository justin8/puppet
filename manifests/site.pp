Exec {
  path => '/usr/bin',
}

node default {
  include os_default
  include collectd
}

node 'abachi.dray.be' inherits default {
  include collectd::server
  include collectd::physical
  include httpd
  include httpd::sync
  include jenkins
  include puppetmaster

  class { 'repo': owner => 'jenkins', group => 'jenkins'; }
  class { 'jenkins::slave': remote => false; }

  realize (
    Httpd::Vhost['abachi.dray.be'],
    Httpd::Vhost['couchpotato.dray.be'],
    Httpd::Vhost['drone.dray.be'],
    Httpd::Vhost['jenkins.dray.be'],
    Httpd::Vhost['sab.dray.be'],
    Httpd::Vhost['sickbeard.dray.be'],
    Httpd::Vhost['transmission.dray.be'],
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
  include httpd::sync
  include os_default::desktop
  include repo
}

node 'zingana.dray.be' inherits default {
  include httpd::sync
  include httpd::blog
  include repo
}
