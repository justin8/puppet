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
  include jenkins::master
  include jenkins::slave
  include mediaserver
  include puppetmaster
  include repo

  class { 'btsync::system':
    user  => 'downloads',
    group => 'downloads',
  }

  vhost { 'abachi':
    url       => 'abachi.dray.be',
    www_root  => '/srv/http',
    autoindex => 'on',
    auth_basic_user_file => '/srv/htpasswd',
  }

  s3sync { "public":
    path => '/srv/public',
    www_root => '/srv/public'
    poll => true,
  }
}

node 'ironwood.dray.be' {
  include os_default
  include os_default::mail
  include os_default::desktop
}

node /^(hickory|tamarack).*/ {
  include os_default
  include os_default::mail
  include openvpn
  include btsync::system
  include blog

  class { 'repo':
    readonly => true,
  }

}
