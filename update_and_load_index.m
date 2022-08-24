function ss_index = update_and_load_index(pkg)
% UPDATE_AND_LOAD_INDEX Download and load last version of the SuiteSparse index.
%  SS_INDEX = UPDATE_AND_LOAD_INDEX(PKG) returns the data structure contained in
%  the latest version of the index file of the SuiteSparse Matrix Collection.
%  This is downloaded from the internet.
%
%  See also GET_PKG_INFO.
  index_filename = 'ss_index.mat';
  index_file_url = [pkg.ss_url '/files/' index_filename];
  index_file_path = [pkg.ss_private_root_dir filesep index_filename];
  websave(index_file_path, index_file_url);
  tmp = load(index_filename); % Contains struct ss_index.
  ss_index = tmp.ss_index;
end