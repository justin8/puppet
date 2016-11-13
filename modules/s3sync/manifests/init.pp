define s3sync($name = $title,
              $path,
              $bucket,
              $bucket_path = '/',
) {
  include s3sync::setup
  include incron

  incron { "update-${name}":
    user    => 'root',
    command => "/usr/bin/aws s3 sync --follow-symlinks \"${path}\" ${bucket}"
    path    => ${path},
    mask    => ['IN_CLOSE_WRITE', 'IN_MOVED_TO'],
  }

}
