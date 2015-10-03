class os_default::os_specifics::archlinux {

  require os_default::os_specifics::archlinux_packages

  ensure_packages(['apacman', 'avahi', 'bind-tools', 'nss-mdns', 'pkgfile', 'pkgstats'])

  if $architecture == 'x86_64' { ensure_packages(['the_silver_searcher']) }

  exec { 'append local domain':
    path    => '/usr/bin',
    #command => 'printf "\n\nsearch_domains=\'local dray.be\'\n" >> /etc/resolvconf.conf; resolvconf -u',
    command => 'printf "\n\nsearch_domains=\'local dray.be\'\n" >> /etc/resolvconf.conf',
    unless  => 'grep -q "search_domains" /etc/resolvconf.conf',
  }

  # Package manager config

  cron { 'create-package-list':
    command  => 'pacman -Q > /etc/package-list',
    user     => 'root',
    minute   => '0',
    hour     => '0',
    weekday  => '*',
    monthday => '*',
    month    => '*',
  }

  cron { 'update-pkgfile':
    command  => 'pkgfile -u &>/dev/null',
    user     => 'root',
    minute   => '0',
    hour     => '3',
    weekday  => '*',
    monthday => '*',
    month    => '*',
  }
}
