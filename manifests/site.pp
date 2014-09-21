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
  include repo
  include jenkins
  include puppetmaster

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
  include jenkins::slave
  class { 'xbmc':
    user  => 'jdray',
    cache => False,
  }
}

node 'huon.dray.be' inherits default {
  include jenkins::slave
}

node 'mahogany.dray.be' inherits default {
  class { 'xbmc':
    user => 'xbmc',
  }
}

node 'ironwood.dray.be' inherits default {
  include btsync::system
  include collectd::physical
  class { 'xbmc':
    user => 'justin',
  }
}

node /xbmc/ inherits default {
  include collectd::physical
  include xbmc::standalone
}

node 'sugi.dray.be' inherits default {
  include collectd::physical
  include jenkins::slave
}

node 'wkmil0393.mil.wotifgroup.com' inherits default {
  include collectd::physical
  include collectd::server
  include httpd
  include httpd::sync
}

node 'zingana.dray.be' inherits default {
  include httpd::sync
  include httpd::blog
}
