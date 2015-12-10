Exec {
  path => $::path,
}

Vcsrepo {
  provider => 'git',
}

File {
  backup => false,
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

node 'hemlock.dray.be' {
  include os_default
  include os_default::mail
  include mediaserver::downloader
}

node 'ironwood.dray.be' {
  include os_default
  include os_default::mail
  include os_default::desktop
}

node /^(cypress|hickory).*/ {
  include os_default
  include os_default::mail
  include openvpn

  $mail_options = {
    service => 'Mailgun',
    auth => {
      user => 'postmaster@mg.dray.be',
      pass => hiera('blog_pass'),
    }
  }
  include ghost
  include nodejs
  vhost { 'www':
    url      => 'www.dray.be',
    upstream => 'localhost:2368',
  }
  ghost::instance { 'blog':
    url          => 'http://www.dray.be',
    version      => '0.7.1',
    service_type => 'systemd',
    transport    => 'SMTP',
    mail_options => $mail_options,
  }

  class { 'repo':
    readonly => true,
  }

  vhost { 'public':
    url      => 'public.dray.be',
    www_root => '/srv/public',
    sync     => true,
  }
}

node /^.*mediacenter.*/ {
  include os_default
  include os_default::mail
  include mediacenter
}

node /^dalemc.*/ {
  include os_default
  include openvpn
}

node /^monitor.*/ {
  include os_default
  include openvpn
  #include monitoring::server

  vhost { 'public':
    url      => 'public.dray.be',
    www_root => '/srv/public',
    sync     => true,
  }
}
