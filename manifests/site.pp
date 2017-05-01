Exec {
  path => $::path,
}

Vcsrepo {
  provider => 'git',
}

File {
  backup => false,
}

if $operatingsystemmajrelease == '16.10' and $operatingsystem == 'Ubuntu' {
  Service {
    provider => 'systemd',
  }
}

if $operatingsystemmajrelease == '16.04' and $operatingsystem == 'Ubuntu' {
  Service {
    provider => 'systemd',
  }
}

if $operatingsystemmajrelease == '15.10' and $operatingsystem == 'Ubuntu' {
  Service {
    provider => 'systemd',
  }
}

if $operatingsystemmajrelease == '15.04' and $operatingsystem == 'Ubuntu' {
  Service {
    provider => 'systemd',
  }
}

if $operatingsystemmajrelease >= '8' and $operatingsystem == 'Debian' {
  Service {
    provider => 'systemd',
  }
}

node 'default' {
  include os_default
  include os_default::mail
}

node 'abachi.dray.be' {
  include os_default
  include os_default::mail
  include mediaserver
  include puppetmaster

  vhost { 'abachi':
    url       => 'abachi.dray.be',
    www_root  => '/srv/http',
    autoindex => 'on',
    auth_basic_user_file => '/srv/htpasswd',
  }

  vhost { 'hass':
    url                  => 'hass.dray.be',
    upstream             => '192.168.1.177:8123',
  }
}
