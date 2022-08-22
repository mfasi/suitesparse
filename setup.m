function setup()

  pkg = get_pkg_info();

  % Donwload the index file.
  ss_index = update_and_load_index(pkg);

  % Create all group directories.
  update_suitesparse_groups(pkg, ss_index);
  update_timestamp(pkg, ss_index);
end