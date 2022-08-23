function timestamp_abs_path = compute_timestamp_path(pkg)
  timestamp_filename = './timestamp';
  timestamp_abs_path = [pkg.ss_private_root_dir filesep timestamp_filename];
end