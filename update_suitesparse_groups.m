function update_suitesparse_groups(pkg, mat_index, csv_index)
% UPDATE_SUITESPARSE_GROUPS Update groups and corresponding matrix generators.
%   UPDATE_SUITESPARSE_GROUPS(PKG,MAT_INDEX,CSV_INDEX) creates a directory in
%   the current Anymatrix installation for each group in the index, and then
%   produces a matrix generator for each matrix therein
%
%  See also GET_PKG_INFO, UPDATE_AND_LOAD_INDEX, CREATE_GROUP_DIRECTORY,
%  CREATE_MATRIX_GENERATOR.

% Generate the matrix generators in ephemeral groups.
  if ~exist(pkg.ss_matfiles_dir)
    mkdir(pkg.ss_matfiles_dir);
  end
  n_matrices = length(mat_index.Group);
  for i = 1:n_matrices
    curr_mat.index = i;
    curr_mat.group_ID = mat_index.Group{i};
    curr_mat.matrix_ID = mat_index.Name{i};

    % Create a new directory for the group of the current matrix, if necessary.
    curr_mat.group_dir = [pkg.anymatrix_root_dir filesep curr_mat.group_ID];
    curr_mat.group_private_dir = [curr_mat.group_dir filesep 'private'];
    curr_mat.group_matfiles_dir = [curr_mat.group_private_dir filesep 'matfiles'];
    if ~exist(curr_mat.group_dir, 'dir')
      create_group_directory(curr_mat)
    end

    % Create a new generator for the current matrix in the group directory.
    create_matrix_generator(pkg, mat_index, csv_index, curr_mat);
  end
end