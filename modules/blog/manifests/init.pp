class blog {
  include btsync::system
  include openvpn

  $gdrive_key = hiera('gdrive_key')

  vhost { 'www':
    url      => 'www.dray.be',
    upstream => 'localhost:2368',
  }

  class { 'ghost':
    include_nodejs => true,
  }

  $mail_options = {
    service => 'Mailgun',
    auth => {
      user => 'postmaster@mg.dray.be',
      pass => hiera('blog_pass'),
    }
  }

  ghost::instance { 'blog':
    url          => 'http://www.dray.be',
    version      => '0.8.0',
    service_type => 'systemd',
    transport    => 'SMTP',
    mail_options => $mail_options,
  }

  file { '/etc/cron.daily/backup-blog':
    ensure  => file,
    mode    => '0755',
    content => template('blog/backup-blog.erb'),
  }
}
