node default {
  include os_default
  include collectd
}

node 'abachi.dray.be' inherits default {
  include collectd::server
  include collectd::physical
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
