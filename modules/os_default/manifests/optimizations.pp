class os_default::optimizations {
  service {
    'nscd':
      ensure  => running,
      enable  => true,
  }

  # Fix for slow drives causing hangs
  # See: http://lwn.net/Articles/572911/
  sysctl {
    'vm.dirty_background_bytes': value => '16777216';
    'vm.dirty_bytes': value => '50331648';
    # Prioritize inode/dentry cache over block cache
    'vm.vfs_cache_pressure': value => '50';
  }

}
