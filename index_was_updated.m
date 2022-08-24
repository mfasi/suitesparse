function new_version_found = index_was_updated(pkg, ss_index)
% INDEX_WAS_UPDATED Check if the index file has been updated.
%  NEW_VERSION_FOUND = INDEX_WAS_UPDATED(PKG,SS_INDEX) is true if the timestamp of
%  SS_INDEX is more recent that that of SuiteSparse group as specified in PKG,
%  and false otherwise.
%
%  See also GET_PKG_INFO, UPDATE_AND_LOAD_INDEX, UPDATE_TIMESTAMP.

  timestamp_abs_path = compute_timestamp_path(pkg);

  new_version_found = true;
  if exist(timestamp_abs_path, 'file')
    % If timestamp file already present, check if update is needed.
    timestamp_file = fopen(timestamp_abs_path, 'r');
    [old_timestamp, line_terminator] = fgets(timestamp_file);
    fclose(timestamp_file);
    if strcmp(ss_index.LastRevisionDate, old_timestamp)
      % No need to update, index file has not changed.
      new_version_found = false;
    end
  end
end
