node default {
  include os_default
}

node 'bloodwood.dray.be' inherits default {
  include puppetmaster
}
