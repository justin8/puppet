class doge {

  $packages = [ 'amdapp-sdk', 'catalyst-hook', 'cgminer-gpu', 'ncurses' ]
  package { $packages: ensure => installed }

  file {
    '/etc/cgminer.conf':
        mode    => '0664',
        content => template('doge/cgminer.conf.erb'),
        notify  => Service['cgminer']
  }

  service {
    'cgminer':
      ensure => running,
      enable => true;

    'catalyst-hook':
      ensure => running,
      enable => true;
  }

}
