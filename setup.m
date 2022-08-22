function setup()
  pkg.ss_url = 'https://sparse.tamu.edu/';
  pkg.anymatrix_root_dir = fileparts(which('anymatrix'));
  pkg.ss_private_root_dir = fileparts(mfilename('fullpath'));

  % Download and load index.
  index_filename = 'ss_index.mat';
  index_file_url = [pkg.ss_url '/files/' index_filename];
  index_file_path = [pkg.ss_private_root_dir filesep index_filename];
  websave(index_file_path, index_file_url);
  tmp = load(index_filename); % Contains struct ss_index.
  ss_index = tmp.ss_index;

  % Check if update is needed using a file that contains a timestamp.
  timestamp_filename = './timestamp';
  timestamp_file_abs_path = [pkg.ss_private_root_dir filesep timestamp_filename];
  if exist(timestamp_file_abs_path, 'file')
    % If timestamp file already present, check if update is needed.
    timestamp_file = fopen(timestamp_file_abs_path, 'r');
    [old_timestamp, line_terminator] = fgets(timestamp_file);
    fclose(timestamp_file);
    if strcmp(ss_index.LastRevisionDate, old_timestamp)
      return; % No need to update, index file has not changed.
    end
  end

  % If an update is needed or this is the first time the collection is
  % generated, then update the timestamp.
   timestamp_file = fopen(timestamp_file_abs_path, 'w');
   % fprintf(timestamp_file, ss_index.LastRevisionDate);
   fclose(timestamp_file);

   % Generate the matrix generators in ephemeral groups.
   n_matrices = length(ss_index.Group);
   for i = 1:10 % n_matrices
     curr_mat.group_ID = lower(ss_index.Group{i});
     curr_mat.matrix_ID = lower(ss_index.Name{i});

     % Create a new directory for the group of the current matrix, if necessary.
     curr_mat.group_dir = [pkg.anymatrix_root_dir filesep curr_mat.group_ID];
     curr_mat.group_private_dir = [curr_mat.group_dir filesep 'private'];
     curr_mat.group_matfiles_dir = [curr_mat.group_private_dir filesep 'matfiles'];
     if ~exist(curr_mat.group_dir, 'dir')
       create_group_dir(curr_mat)
       % else % Killer feature
       %   rmdir(group_dir, 's');
     end

     % Create a new generator for the current matrix in the group directory.
     create_matrix_generator(curr_mat);
   end


   function create_group_dir(curr_mat)
   % Create directory.
     mkdir(curr_mat.group_dir);

     % Create bridge function.
     bridge_filename = [curr_mat.group_dir filesep...
                        'anymatrix_' curr_mat.group_ID '.m'];
     bridge_file = fopen(bridge_filename, 'w');
     fprintf(bridge_file, ['function varargout = anymatrix_' curr_mat.group_ID...
                           '(matrix_name, varargin)\n'...
                           'handle = str2func([''ss_'' matrix_name]);\n'...
                           '[varargout{1:nargout}]'...
                           '= handle(varargin{1:nargin-1});\n end']);
     fclose(bridge_file);

     % Create 'private' and 'private/matfiles' directories.
     % mkdir([group_dir filesep 'private']);
     mkdir(curr_mat.group_matfiles_dir);

     % Create parser function.
     parser_filename = [curr_mat.group_private_dir filesep...
                        'anymatrix_parser_' curr_mat.group_ID '.m'];
     parser_file = fopen(parser_filename, 'w');
     fprintf(parser_file, ['function parsed_name = '...
                           'anymatrix_parser_' curr_mat.group_ID...
                           '(matrix_name)\n'...
                           '  parsed_name = '...
                           'extractAfter(matrix_name, ''ss_'');\n'...
                           'end']);
     fclose(parser_file);

   end

   function create_matrix_generator(curr_mat)
     function_name = ['ss_' curr_mat.matrix_ID];
     generator_filename = [curr_mat.group_private_dir filesep...
                           function_name '.m'];
     generator_file = fopen(generator_filename, 'w');
     fprintf(generator_file, ['function [A, properties] = ' function_name '()\n'...
                              '  matfile_name = '''...
                              curr_mat.group_matfiles_dir filesep...
                              curr_mat.matrix_ID '.mat'';\n'...
                              '  if ~exist(matfile_name, ''file'')\n'...
                              '     matfile_url = '''...
                              pkg.ss_url '/mat/' curr_mat.group_ID...
                              '/' curr_mat.matrix_ID '.mat'';\n'...
                              '    websave(matfile_name, matfile_url);\n'...
                              '  end\n'...
                              '  tmp = load(matfile_name, ''Problem'');\n'...
                              '  A = tmp.Problem.A;\n'...
                              '  properties' '= {};\n'...
                              'end']);
     fclose(generator_file);
   end
end