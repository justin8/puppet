class os_default::mail {
  # Basic config for postfix using mailgun; keeping it simple
  # none of the major postfix modules support Arch and it was
  # too much effort to port them for this little bit of config

  # Using unencrypted port 25 because ubuntu failed to compile
  # in TLS support by default. wtf Ubuntu?
  case $operatingsystem {
    'Archlinux': { $aliases = '/etc/postfix/aliases' }
    'Ubuntu': { $aliases = '/etc/aliases' }
    default: { fail('Unsupported OS') }
  }

  ensure_packages(['postfix'])

  $smtp_sasl_password_maps_data = hiera('smtp_sasl_password_maps')

  service { 'postfix':
    ensure => running,
    enable => true,
  }

  File_line {
    path    => '/etc/postfix/main.cf',
    require => Package['postfix'],
    notify  => Service['postfix'],
  }

  file_line { 'relayhost':
    line  => 'relayhost = [smtp.mailgun.org]:25',
    match => '^relayhost',
  }

  file_line { 'smtp_sasl_auth_enable':
    line  => 'smtp_sasl_auth_enable = yes',
    match => '^smtp_sasl_auth_enable',
  }

  file_line { 'smtp_sasl_password_maps':
    line  => "smtp_sasl_password_maps = $smtp_sasl_password_maps_data",
    match => '^smtp_sasl_password_maps',
  }

  file_line { 'smtp_sasl_security_options':
    line  => 'smtp_sasl_security_options = noanonymous',
    match => '^smtp_sasl_security_options',
  }

  file_line { 'inet_interfaces':
    line  => 'inet_interfaces = 127.0.0.1',
    match => '^inet_interfaces',
  }

  file_line { 'aliases':
    path   => $aliases,
    line   => "root: ${hostname}@dray.be",
    match  => '^root:',
    notify => Exec['newaliases'],
  }

  exec { 'newaliases':
    refreshonly => true,
  }
}
