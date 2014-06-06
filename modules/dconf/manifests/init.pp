class dconf {

  package { [ 'dconf', 'dbus' ]:
    ensure => present,
  }
}
