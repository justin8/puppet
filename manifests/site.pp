Exec {
  path => $::path,
}

Vcsrepo {
  provider => 'git',
}

File {
  backup => false,
}

if $operatingsystemrelease == '15.04' {
  Service {
    provider => 'systemd',
  }
}

node 'default' {
  include os_default
}

node 'abachi.dray.be' {
  include os_default
  include monitoring::server
  include jenkins::master
  include jenkins::slave
  include mediaserver::manager
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
}

node 'hemlock.dray.be' {
  include os_default
  include mediaserver::downloader
}

node 'ironwood.dray.be' {
  include os_default
  include os_default::desktop
}

node /^cypress.*/ {
  include os_default
  include openvpn

  include ghost
  ghost::instance { 'blog':
    url          => 'www.dray.be',
    version      => '0.7.1',
    service_type => 'systemd',
  }

  class { 'repo':
    readonly => true,
  }

  vhost { 'public':
    url      => 'public.dray.be',
    www_root => '/srv/public',
    sync     => true,
  }

  vhost { 'www':
    url      => 'www.dray.be',
    upstream => 'localhost:2368',
  }
}

node /^.*mediacenter.*/ {
  include os_default
  include mediacenter
}

node /^dalemc.*/ {
  include os_default
  include openvpn
}

node 'wkmil0393.mil.wotifgroup.com' {
  include os_default
  include os_default::desktop
}
