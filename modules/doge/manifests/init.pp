class doge {

  $packages = [ 'cgminer-gpu', 'opencl-catalyst', 'ncurses' ]
  package { $packages: ensure => installed }

  file {
    '/usr/local/bin/generate-cgminer-conf':
      mode   => '774',
      source => 'puppet:///modules/doge/generate-cgminer-conf'
  }

  exec {
    '/usr/local/bin/generate-cgminer-conf':
      path    => '/usr/bin',
      creates => '/etc/cgminer.conf',
      require => File['/usr/local/bin/generate-cgminer-conf']
  }

  service {
    'cgminer':
      ensure  => running,
      enable  => true,
      require => Exec['/usr/bin/generate-cgminer-conf'],
  }

}
