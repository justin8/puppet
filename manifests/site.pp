node default {
  include os_default
}

node 'bloodwood.dray.be' inherits default {
  include puppetmaster
}

node 'ironwood.dray.be' inherits default {
  class { 'xbmc':
    user => 'justin',
    standalone => 'false',
  }
}

node 'poplar.dray.be' inherits default {
  class { 'xbmc': }
}

node 'maple.dray.be' inherits default {
  class { 'xbmc': }
}
