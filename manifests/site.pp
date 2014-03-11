node default {
  include os_default
  include collectd
}

node 'abachi.dray.be' inherits default {
  include collectd::server
  include collectd::physical
  include httpd
  include repo
  include jenkins
  include puppetmaster

  class { 'jenkins::slave': remote => false; }

  realize (
    Httpd::Vhost['abachi.dray.be'],
    Httpd::Vhost['couchpotato.dray.be'],
    Httpd::Vhost['deluge.dray.be'],
    Httpd::Vhost['jenkins.dray.be'],
    Httpd::Vhost['repo.dray.be'],
    Httpd::Vhost['sab.dray.be'],
    Httpd::Vhost['sickbeard.dray.be'],
  )
}

node 'huon.dray.be' inherits default {
  include jenkins::slave
}

node 'mahogany.dray.be' inherits default {
  class { 'xbmc':
    standalone => false,
  }
}

node 'ironwood.dray.be' inherits default {
  include collectd::physical
  class { 'xbmc':
    user       => 'justin',
    standalone => false,
  }
}

node 'maple.dray.be' inherits default {
  include collectd::physical
  class { 'xbmc': }
}

node 'poplar.dray.be' inherits default {
  include collectd::physical
  class { 'xbmc': }
}

node 'sugi.dray.be' inherits default {
  include collectd::physical
  include jenkins::slave
}

node 'wkmil0393.wotifgroup.com' inherits default {
  include collectd::physical
  include collectd::server
}

node 'zingana.dray.be' inherits default {
  include httpd::blog
}
