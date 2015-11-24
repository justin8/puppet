class monitoring::params {
  contain monitoring::package

  $grafana_config = '/etc/grafana/grafana.ini'
  $influxdb_service = 'influxdb'
  $grafana_service = 'grafana'

  case $osfamily {
    'Archlinux': {
      $telegraf_config = '/etc/telegraf/telegraf.conf'
      $influxdb_config = '/etc/influxdb.conf'
    }
    'Debian': {
      $telegraf_config = '/etc/opt/telegraf/telegraf.conf'
      $influxdb_config = '/etc/influxdb/influxdb.conf'
    }
    default: {
      fail('Unsupported OS')
    }
  }

}
