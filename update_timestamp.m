function update_timestamp(pkg, mat_index)
% UPDATE_TIMESTAMP Update timestamp file of Anymatrix interface to SuiteSparse.
%  UPDATE_TIMESTAMP(PKG,MAT_INDEX) updates the timestamp file of the SuiteSparse
%  interface specified in PKG using the date in MAT_INDEX.
%
% See also GET_PKG_INFO, COMPUTE_TIMESTAMP_PATH.

  timestamp_abs_path = compute_timestamp_path(pkg);

  timestamp_file = fopen(timestamp_abs_path, 'w');
  fprintf(timestamp_file, mat_index.LastRevisionDate);
  fclose(timestamp_file);
end