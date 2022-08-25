function teardown()
% TEARDOWN Delete all Anymatrix groups in the SuiteSparse Matrix Collection.

% Delete group directories.
  pkg = get_pkg_info();
  mat_index = update_and_load_index(pkg);
  for i = 1:length(mat_index.Name)
    % Create a new directory for the group of the current matrix, if necessary.
    group_dir = [pkg.anymatrix_root_dir filesep mat_index.Group{i}];
    if exist(group_dir, 'dir')
      rmdir(group_dir, 's');
    end
  end

  % Delete timestamp file.
  timestamp_abs_path = compute_timestamp_path(pkg);
  if exist(timestamp_abs_path, 'file')
    delete(timestamp_abs_path);
  end
end
