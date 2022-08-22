function update_suitesparse_groups(pkg, ss_index)
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