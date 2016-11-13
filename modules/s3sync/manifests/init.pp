define s3sync($path,
              $bucket,
              $bucket_path = '/',
) {
  include s3sync::setup
  include incron

  incron { "update-${title}":
    user    => 'root',
    command => "/usr/bin/aws s3 sync --follow-symlinks --delete \"${path}\" ${bucket}",
    path    => $path,
    mask    => ['IN_CLOSE_WRITE', 'IN_MOVED_TO'],
  }

}
