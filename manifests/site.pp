node default {
  include os_default
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
