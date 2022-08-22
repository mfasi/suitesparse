function setup()

  pkg = get_pkg_info();

  % Download and load index.
  ss_index = download_and_load_index(pkg);

  % Check if update is needed using a file that contains a timestamp.
  timestamp_filename = './timestamp';
  timestamp_file_abs_path = [pkg.ss_private_root_dir filesep timestamp_filename];
  if exist(timestamp_file_abs_path, 'file')
    % If timestamp file already present, check if update is needed.
    timestamp_file = fopen(timestamp_file_abs_path, 'r');
    [old_timestamp, line_terminator] = fgets(timestamp_file);
    fclose(timestamp_file);
    if strcmp(ss_index.LastRevisionDate, old_timestamp)
      return; % No need to update, index file has not changed.
    end
  end

  % If an update is needed or this is the first time the collection is
  % generated, then update the timestamp.
  timestamp_file = fopen(timestamp_file_abs_path, 'w');
  % fprintf(timestamp_file, ss_index.LastRevisionDate);
  fclose(timestamp_file);

  % Generate the matrix generators in ephemeral groups.
  if ~exist(pkg.ss_matfiles_dir)
    mkdir(pkg.ss_matfiles_dir);
  end
  n_matrices = length(ss_index.Group);
  for i = 1:n_matrices
    curr_mat.index = i;
    curr_mat.group_ID = ss_index.Group{i};
    curr_mat.matrix_ID = ss_index.Name{i};

    % Create a new directory for the group of the current matrix, if necessary.
    curr_mat.group_dir = [pkg.anymatrix_root_dir filesep curr_mat.group_ID];
    curr_mat.group_private_dir = [curr_mat.group_dir filesep 'private'];
    curr_mat.group_matfiles_dir = [curr_mat.group_private_dir filesep 'matfiles'];
    if ~exist(curr_mat.group_dir, 'dir')
      create_group_directory(curr_mat)
    end

    % Create a new generator for the current matrix in the group directory.
    create_matrix_generator(pkg, ss_index, curr_mat);
  end
end