define s3sync($path,
              $bucket,
              $bucket_path = '/',
              $poll = false
) {
  include s3sync::setup
  include incron

  $command = "/usr/bin/aws s3 sync --follow-symlinks --delete \"${path}\" ${bucket}"

  if $poll == True {
    cron { "update-${title}":
      user     => 'root',
      command  => $command,
      minute   => '*/10',
      hour     => '*',
      month    => '*',
      weekday  => '*',
      monthday => '*',
    }
  } else {
    incron { "update-${title}":
      user    => 'root',
      command => $command,
      path    => $path,
      mask    => ['IN_CLOSE_WRITE', 'IN_MOVED_TO'],
    }
  }

}
