class monitoring::package {
  include apt

  $distro = downcase($operatingsystem)

  case $osfamily {
    'Debian': {
      include apt

      apt::source { 'influxdb':
        location =>  "https://repos.influxdata.com/${distro}",
        repos    => 'stable',
        key      => {
          'id'     => '684A14CF2582E0C5',
          'server' => 'pgp.mit.edu',
        },
        include  => {
          'src' => false,
          'deb' => true,
        },
      }

      apt::source { 'grafana':
        location => "https://packagecloud.io/grafana/stable/${distro}",
        repos    => 'main',
        key      => {
          'id'     => 'C2E73424D59097AB',
          'server' => 'pgp.mit.edu',
        },
        include  => {
          'src' => false,
          'deb' => true,
        },
      }
    }
  }
}
