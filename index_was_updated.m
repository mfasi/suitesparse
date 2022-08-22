function new_version_found = index_was_updated(pkg, ss_index)
% Check if the SS_INDEX is newer than last version that was processed.
% The function uses a timestamp file.
  timestamp_filename = './timestamp';
  timestamp_abs_path = [pkg.ss_private_root_dir filesep timestamp_filename];

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

  % If the index file has changed or this is the first time the collection is
  % generated, then update the timestamp.
  if new_version_found
    timestamp_file = fopen(timestamp_abs_path, 'w');
    fprintf(timestamp_file, ss_index.LastRevisionDate);
    fclose(timestamp_file);
  end
end
