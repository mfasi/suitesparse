function timestamp_abs_path = compute_timestamp_path(pkg)
% COMPUTE_TIMESTAMP_PATH Return the absoluto path of the timestamp file.
%  TIMESTAMP_ABS_PATH = COMPUTE_TIMESTAMP_PATH(PKG) is the absolute path of
%  the timestamp file for the SuiteSparse group specified in PKG.
%
%  See also GET_PKG_INFO.
  timestamp_filename = './timestamp';
  timestamp_abs_path = [pkg.ss_private_root_dir filesep timestamp_filename];
end