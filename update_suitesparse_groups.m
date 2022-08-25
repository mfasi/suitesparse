function update_suitesparse_groups(pkg, mat_index, csv_index)
% UPDATE_SUITESPARSE_GROUPS Update groups and corresponding matrix generators.
%   UPDATE_SUITESPARSE_GROUPS(PKG,MAT_INDEX,CSV_INDEX) creates a directory in
%   the current Anymatrix installation for each group in the index, and then
%   produces a matrix generator for each matrix therein
%
%  See also GET_PKG_INFO, UPDATE_AND_LOAD_INDEX, CREATE_GROUP_DIRECTORY,
%  CREATE_MATRIX_GENERATOR.

  if ~exist(pkg.ss_matfiles_dir) % Used for SVD file.
    mkdir(pkg.ss_matfiles_dir);
  end

  % Generate the matrix generators in ephemeral groups.
  n_matrices = length(mat_index.Group);
  last_group = '';
  for i = 1:n_matrices
    curr_mat.index = i;
    curr_mat.group_ID = mat_index.Group{i};
    curr_mat.matrix_ID = mat_index.Name{i};

    % Operations to be performed at the start of a new group.
    if ~strcmp(last_group, curr_mat.group_ID)
      % Close previous group, if any.
      if ~strcmp(last_group, '')
        % Close property file.
        fprintf(curr_mat.group_property_file, '  };\n');
        fclose(curr_mat.group_property_file);

        % Close Contents.m file.

      end

      % Store information for new group.
      last_group = curr_mat.group_ID;
      curr_mat.group_dir = [pkg.anymatrix_root_dir filesep curr_mat.group_ID];
      curr_mat.group_private_dir = [curr_mat.group_dir filesep 'private'];
      curr_mat.group_matfiles_dir = [curr_mat.group_private_dir filesep...
                                     'matfiles'];

      % Create new group directory (with bridge files).
      if ~exist(curr_mat.group_dir, 'dir')
        create_group_directory(curr_mat);
      end

      % Open property file.
      property_file_name = [curr_mat.group_private_dir filesep...
                            'ss_am_properties.m'];
      curr_mat.group_property_file = fopen(property_file_name, 'w');
      fprintf(curr_mat.group_property_file,...
              'function P = am_properties()\n\n  P = {\n');

      % Open Contents.m file.

    end

    % Create a new generator for the current matrix in the group directory.
    create_matrix_generator(pkg, mat_index, csv_index, curr_mat);
  end

  % Close property file for last group.
  fprintf(curr_mat.group_property_file, '  };\nend');
  fclose(curr_mat.group_property_file);

  % Clone Contents.m file for last group.

end