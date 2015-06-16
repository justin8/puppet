# == Class: openvpn
#
# Module to connect a remote machine to the central network
#
# === Parameters
#
# None! Totally auto.
#
# However, all puppet-managed clients use a shared key currently

class openvpn {

  if $systemd_available == 'true' {
    ensure_packages(['openvpn'])

    file { ['/etc/openvpn/certs', '/etc/openvpn']:
      ensure => directory,
    }

    file { '/etc/openvpn/certs/dray.be-ca.crt':
      source => 'puppet:///modules/openvpn/certs/dray.be-ca.crt',
    }

    file { '/etc/openvpn/certs/dray.be-client.crt':
      source => 'puppet:///modules/openvpn/certs/dray.be-client.crt',
    }

    file { '/etc/openvpn/certs/dray.be-client.key':
      mode    => '0700',
      content => hiera('openvpn_key'),
    }

    file { '/etc/openvpn/dray.be.conf':
      source => 'puppet:///modules/openvpn/dray.be.conf',
    }

    file { "/etc/systemd/system/openvpn@.service":
      source => 'puppet:///modules/openvpn/openvpn@.service',
      notify => Exec['systemd-daemon-reload'],
    }

    file { "/usr/local/sbin/maintain-vpn":
      mode   => '0755',
      notify => Exec['maintain-vpn'],
      source => 'puppet:///modules/openvpn/maintain-vpn',
    }

    exec { "maintain-vpn":
      command     => '/usr/local/sbin/maintain-vpn',
      refreshonly => true,
    }


    cron { 'maintain-vpn':
      command => '/usr/local/sbin/maintain-vpn',
      user     => 'root',
      minute   => '*/5',
      hour     => '*',
      weekday  => '*',
      monthday => '*',
      month    => '*',
    }
  }
}