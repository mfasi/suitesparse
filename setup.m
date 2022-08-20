function setup()
  suitesparse_url = 'https://sparse.tamu.edu/';
  index_file_name = 'ss_index.mat';

  % Download and load index.
  index_file_url = [suitesparse_url '/files/' index_file_name];
  websave(index_file_name, index_file_url);
  tmp = load(index_file_name); % Contains struct ss_index.
  ss_index = tmp.ss_index;

  % Check if update is needed using a file that contains a timestamp.
  timestamp_filename = './timestamp';
  if exist(timestamp_filename, 'file')
    % If timestamp file already present, check if update is needed.
    timestamp_file = fopen(timestamp_filename, 'r');
     [old_timestamp, line_terminator] = fgets(timestamp_file);
     fclose(timestamp_file);
     if strcmp(ss_index.LastRevisionDate, old_timestamp)
       return; % No need to update, index file has not changed.
     end
   end

   % If an update is needed or this is the first time the collection is
   % generated, then update the timestamp.
   timestamp_file = fopen(timestamp_filename, 'w');
   % fprintf(timestamp_file, ss_index.LastRevisionDate);
   fclose(timestamp_file);

   % Generate the matrix generators in ephemeral groups.
   anymatrix_root_dir = fileparts(which('anymatrix'));
   n_matrices = length(ss_index.Group);
   for i = 1:n_matrices
     group_ID = ss_index.Group{i};
     matrix_ID = ss_index.Name{i};

     % Create a new directory for the group of the current matrix, if necessary.
     group_dir = [anymatrix_root_dir filesep group_ID];
     if ~exist(group_dir, 'dir')
       create_group_dir(group_ID, group_dir)
     end

     % Create a new generator for the current matrix in the group directory.
   end

   function create_group_dir(group_ID, group_dir)

   % Create directory.
     mkdir(group_dir);

     % Create bridge function.
     bridge_filename = [group_dir filesep 'anymatrix_' group_ID '.m'];
     bridge_file = fopen(bridge_filename, 'w');
     fprintf(bridge_file, ['function varargout = anymatrix_' group_ID...
                           '(matrix_name, varargin)\n'...
                           'handle = str2func(matrix_name);\n'...
                           '[varargout{1:nargout}]'...
                           '= handle(varargin{1:nargin-1});\n end']);
     fclose(bridge_file);

     % Create private directory.
     mkdir([group_dir filesep 'private']);
   end
end