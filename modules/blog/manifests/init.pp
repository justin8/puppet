class os_default {
  include btsync::system
  include openvpn
  include btsync::system

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

}
