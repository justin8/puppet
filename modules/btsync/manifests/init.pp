class btsync( $webui = 'local' ) {

  package { 'btsync':
    ensure => present,
  }

  file { '/var/lib/btsync/custom':
    ensure => directory,
    purge  => true,
    force  => true,
  }

}
