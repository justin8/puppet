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
  include mediaserver::manager
  include mediaserver::downloader
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

  vhost { 'public':
    url      => 'public.dray.be',
    www_root => '/srv/public',
    sync     => true,
  }

  vhost { 'ark':
    url => 'ark.dray.be',
    www_root => '/srv/ark',
    https => false,
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

  vhost { 'public':
    url      => 'public.dray.be',
    www_root => '/srv/public',
    sync     => true,
  }
}
