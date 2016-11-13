class s3sync::setup {

  ensure_packages(['aws-cli'])

  $aws_credentials = hiera('aws_credentials')
  $aws_access_key_id = $aws_credentials['aws_access_key_id']
  $aws_secret_access_key = $aws_credentials['aws_secret_access_key']

  file {
    "/root/.aws":
      ensure => directory,
      mode   => '0700';

    "/root/.aws/credentials":
      mode => '0600',
      content => template('s3sync/credentials'),
  }

}
