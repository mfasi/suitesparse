function new_version_found = index_is_newer(pkg, ss_index)
% Check if the SS_INDEX is newer than last version that was processed.
% The function uses a timestamp file.

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
