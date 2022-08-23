function update_timestamp(pkg, ss_index)
  timestamp_abs_path = compute_timestamp_path(pkg);

  % If the index file has changed or this is the first time the collection is
  % generated, then update the timestamp.
  timestamp_file = fopen(timestamp_abs_path, 'w');
  fprintf(timestamp_file, ss_index.LastRevisionDate);
  fclose(timestamp_file);
end