node default {
  include os_default
}

node 'bloodwood.dray.be' inherits default {
  include puppetmaster
}

node 'ironwood.dray.be' inherits default {
  include xbmc
}
node 'poplar.dray.be' inherits default {
  include xbmc
}

node 'maple.dray.be' inherits default {
  include xbmc
}
