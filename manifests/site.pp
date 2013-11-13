node default {
  include os_default
  include collectd
}

node 'abachi.dray.be' inherits default {
  include collectd::server
  include collectd::physical
  include httpd
  realize (
    Httpd::Vproxy['sab.dray.be'],
    Httpd::Vproxy['sickbeard.dray.be'],
  )
}

node 'bloodwood.dray.be' inherits default {
  include puppetmaster
}

node 'mahogany.dray.be' inherits default {
  class { 'xbmc':
    standalone => 'false',
  }
}

node 'ironwood.dray.be' inherits default {
  include collectd::physical
  class { 'xbmc':
    user => 'justin',
    standalone => 'false',
  }
}

node 'poplar.dray.be' inherits default {
  include collectd::physical
  class { 'xbmc': }
}

node 'maple.dray.be' inherits default {
  include collectd::physical
  class { 'xbmc': }
}

node 'wkmil0393.wotifgroup.com' inherits default {
  include collectd::physical
  include collectd::server
}

node 'zingana.dray.be' inherits default {
  include httpd::blog
}
