function teardown()
% Delete all groups under suitesparse control.
  pkg = get_pkg_info();
  ss_index = update_and_load_index(pkg);
  for i = 1:length(ss_index.Name)
    % Create a new directory for the group of the current matrix, if necessary.
    group_dir = [pkg.anymatrix_root_dir filesep ss_index.Group{i}];
    if exist(group_dir, 'dir')
      rmdir(group_dir, 's');
    end
  end
end
