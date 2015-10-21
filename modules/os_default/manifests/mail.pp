class os_default::mail {
  # Basic config for postfix using mailgun; keeping it simple
  # none of the major postfix modules support Arch and it was
  # too much effort to port them for this little bit of config

  ensure_packages(['postfix'])

  $smtp_sasl_password_maps_data = hiera('smtp_sasl_password_maps')

  File_line {
    path    => '/etc/postfix/main.cf',
    require => Package['postfix'],
  }

  file_line { 'relayhost':
    line  => 'relayhost = [smtp.mailgun.org]:465',
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

  file_line { 'smtp_tls_wrappermode':
    line  => 'smtp_tls_wrappermode = yes',
    match => '^smtp_tls_wrappermode',
  }

  file_line { 'smtp_tls_security_level':
    line  => 'smtp_tls_security_level = encrypt',
    match => '^smtp_tls_security_level',
  }
}
