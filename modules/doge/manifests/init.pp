class doge {

    $packages = [ 'amdapp-sdk', 'catalyst-hook', 'cgminer-gpu', 'ncurses' ]
        package { $packages: ensure => installed }

    file {
        '/etc/cgminer.conf':
            mode    => '0664',
            content => template('doge/cgminer.conf.erb'),
            notify  => Service['cgminer'];

        '/etc/systemd/system/cgminer.service':
            mode   => '0664',
            source => 'puppet:///modules/doge/cgminer.service',
            notify => [ Exec['reload-daemon-config'], Service['cgminer'] ],
    }

    exec { 'reload-daemon-config':
        refreshonly => true,
        path        => '/usr/bin',
        command     => 'systemctl --system daemon-reload'
    }

    service {
        'cgminer':
            ensure  => running,
            enable  => true,
            require => Exec['reload-daemon-config'];

        'catalyst-hook':
            ensure => running,
            enable => true;
    }

}
