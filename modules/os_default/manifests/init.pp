class os_default {
  include os_default::cron
  include os_default::misc
  include os_default::ntp
  include os_default::optimizations
  include os_default::pacman
  include os_default::ssh
  include os_default::sudo

  $packages = [ 'git', 'rsync', 'pkgfile' ]
  package { $packages: ensure => installed }

  file {
    '/root/.smbcreds':
      mode    => '600',
      content => "username=vms
                  password=nagicsusgemi
                 ";
  }

}
