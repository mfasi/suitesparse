function update()
% Update Update the Anymatrix interface to the SuiteSparse Matrix Collection.

  pkg = get_pkg_info();

  % Donwload the index file and update collection if necessary.
  [mat_index, csv_index] = update_and_load_index(pkg);
  if index_was_updated(pkg, mat_index)
    update_suitesparse_groups(pkg, mat_index, csv_index);
    update_timestamp(pkg, mat_index);
  end
end