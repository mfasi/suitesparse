function setup()
% SETUP Generate the Anymatrix interface to the SuiteSparse Matrix Collection.

  pkg = get_pkg_info();

  % Donwload the index file.
  [mat_index, csv_index] = update_and_load_index(pkg);

  % Create all group directories.
  update_suitesparse_groups(pkg, mat_index, csv_index);
  update_timestamp(pkg, mat_index);
end