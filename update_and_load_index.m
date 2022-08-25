function [mat_index, csv_index] = update_and_load_index(pkg)
% UPDATE_AND_LOAD_INDEX Download and load last version of the SuiteSparse index.
%  SS_INDEX = UPDATE_AND_LOAD_INDEX(PKG) returns the data structure contained in
%  the latest version of the index file of the SuiteSparse Matrix Collection.
%  This is downloaded from the internet.
%
%  See also GET_PKG_INFO.
  mat_index_filename = 'ss_index.mat';
  mat_index_file_url = [pkg.ss_url '/files/' mat_index_filename];
  mat_index_file_path = [pkg.ss_private_root_dir filesep mat_index_filename];
  websave(mat_index_file_path, mat_index_file_url);

  csv_index_filename = 'ssstats.csv';
  csv_index_file_url = [pkg.ss_url '/files/' csv_index_filename];
  csv_index_file_path = [pkg.ss_private_root_dir filesep csv_index_filename];
  websave(csv_index_file_path, csv_index_file_url);

  if nargout > 0
    tmp = load(mat_index_filename); % Contains struct ss_index.
    mat_index = tmp.ss_index;
  end
  if nargout > 1
    csv_index = readtable(csv_index_filename, 'FileType', 'Text'); % Contains struct ss_index.
  end
end