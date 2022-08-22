function update()

  pkg = get_pkg_info();

  % Donwload the index file and update collection if necessary.
  ss_index = update_and_load_index(pkg);
  if index_was_updated(pkg, ss_index)
    update_suitesparse_groups(pkg, ss_index);
  end
end