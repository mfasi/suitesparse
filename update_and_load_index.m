function ss_index = update_and_load_index(pkg)
% Downlaod the latest version of the SuiteSparse index file and return the
% corresponding data structure.
  index_filename = 'ss_index.mat';
  index_file_url = [pkg.ss_url '/files/' index_filename];
  index_file_path = [pkg.ss_private_root_dir filesep index_filename];
  websave(index_file_path, index_file_url);
  tmp = load(index_filename); % Contains struct ss_index.
  ss_index = tmp.ss_index;
end