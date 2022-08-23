function create_matrix_generator(pkg, ss_index, curr_mat)
  % Get matrix properties.
  curr_properties = create_matrix_property_array(pkg, ss_index, curr_mat);

  % Generate matrix generator.
  function_name = ['ss_' curr_mat.matrix_ID];
  generator_filename = [curr_mat.group_private_dir filesep...
                        function_name '.m'];
  generator_file = fopen(generator_filename, 'w');
  fprintf(generator_file, ['function [A, properties] = ' function_name '()\n'...
                           '  matfile_name = '''...
                           curr_mat.group_matfiles_dir filesep...
                           curr_mat.matrix_ID '.mat'';\n'...
                           '  if ~exist(matfile_name, ''file'')\n'...
                           '    matfile_url = '''...
                           pkg.ss_url '/mat/' curr_mat.group_ID...
                           '/' curr_mat.matrix_ID '.mat'';\n'...
                           '    websave(matfile_name, matfile_url);\n'...
                           '  end\n'...
                           '  tmp = load(matfile_name, ''Problem'');\n'...
                           '  A = tmp.Problem.A;\n'...
                           '  properties' '= {\n'...
                           sprintf('%s    ''%s''',...
                                   sprintf('    ''%s'',\n',...
                                           curr_properties{1:end-1}),...
                                   curr_properties{end}) '\n'...
                           '  };\nend']);
  fclose(generator_file);
end

function properties = create_matrix_property_array(pkg, ss_index, curr_mat)
  % Donwload corresponding SVD MAT file (only available for small matrices).
  svd_matfile_url = [pkg.ss_url '/svd/' curr_mat.group_ID '/'...
                     curr_mat.matrix_ID '_SVD.mat'];
  svd_matfile_name = [pkg.ss_matfiles_dir filesep...
                      curr_mat.matrix_ID '_SVD.mat'];
  try
    if ~exist(svd_matfile_name, 'file')
      websave(svd_matfile_name, svd_matfile_url);
    end
    curr_mat.has_svd = true;
    tmp = load(svd_matfile_name);
    curr_mat.sigma_min = min(tmp.S.s);
    curr_mat.sigma_max = max(tmp.S.s);
  catch
    curr_mat.has_svd = false;
  end

  candidates = prop_list();
  properties = cell(0);
  for j = 1:length(candidates)
    curr_property = candidates{j};
    curr_normalized_property = strrep(...
        strrep(curr_property, ' ', '_'), '-', '_');

    curr_handle = str2func(['is_' curr_normalized_property]);

    if curr_handle(curr_mat, ss_index)
      properties{end+1} = curr_property;
    end
  end
end

function out = is_banded(curr_mat, ss_index)
  out = ss_index.lowerbandwidth(curr_mat.index) < ...
        ss_index.nrows(curr_mat.index) || ...
        ss_index.upperbandwidth(curr_mat.index) < ...
        ss_index.ncols(curr_mat.index);
end

function out = is_binary(curr_mat, ss_index)
  out = ss_index.isBinary(curr_mat.index);
end

function out = is_block_Toeplitz(curr_mat, ss_index)
  out = false; % Property not available.
end

function out = is_built_in(curr_mat, ss_index)
  out = false;
end

function out = is_complex(curr_mat, ss_index)
  out = ~ss_index.isReal(curr_mat.index);
end

function out = is_correlation(curr_mat, ss_index)
  out = false; % Property not available.
end

function out = is_defective(curr_mat, ss_index)
  out = false; % Property not available.
end

function out = is_diagonally_dominant(curr_mat, ss_index)
  out = false; % Property not available.
end

function out = is_eigenvalues(curr_mat, ss_index)
  out = false; % Property not available.
end

function out = is_fixed_size(curr_mat, ss_index)
  out = true;
end

function out = is_hankel(curr_mat, ss_index)
  out = false; % Property not available.
end

function out = is_hermitian(curr_mat, ss_index)
  % Complex and Hermitian or real (or binary) and symmetric.
  out = (ss_index.RBtype(curr_mat.index, 1) == 'c' &&...
         ss_index.RBtype(curr_mat.index, 2) == 'h') ||...
         ((ss_index.RBtype(curr_mat.index, 1) == 'r' ||...
           ss_index.RBtype(curr_mat.index, 1) == 'b') &&...
          ss_index.RBtype(curr_mat.index, 2) == 's');
end

function out = is_hessenberg(curr_mat, ss_index)
  out = false; % Property not available.
end

function out = is_idempotent(curr_mat, ss_index)
  out = false; % Property not available.
end

function out = is_indefinite(curr_mat, ss_index)
  out = ss_index.posdef(curr_mat.index) == 0;
end

function out = is_ill_conditioned(curr_mat, ss_index)
  if curr_mat.has_svd
    condA = curr_mat.sigma_max / curr_mat.sigma_min;
    out = condA > 1/eps();
  else
    out = false; % Property not available for large matrices.
  end
end

function out = is_infinitely_divisible(curr_mat, ss_index)
  out = ss_index.posdef(curr_mat.index) == 1;
end

function out = is_integer(curr_mat, ss_index)
  out = ss_index.posdef(curr_mat.index) == 1;
end

function out = is_inverse(curr_mat, ss_index)
  out = ss_index.posdef(curr_mat.index) == 1;
end

function out = is_involutory(curr_mat, ss_index)
  out = false; % Property not available.
end

function out = is_M_matrix(curr_mat, ss_index)
  out = false; % Property not available.
end

function out = is_nilpotent(curr_mat, ss_index)
  out = false; % Property not available.
end

function out = is_nonnegative(curr_mat, ss_index)
  out = ss_index.xmin(curr_mat.index) >= 0;
end

function out = is_normal(curr_mat, ss_index)
  out = false; % Property not available.
end

function out = is_orthogonal(curr_mat, ss_index)
  out = false; % Property not available.
end

function out = is_parameter_dependent(curr_mat, ss_index)
  out = false;
end

function out = is_permutation(curr_mat, ss_index)
  out = false; % Property not available.
end

function out = is_positive(curr_mat, ss_index)
  out = ss_index.xmin(curr_mat.index) > 0;
end

function out = is_positive_definite(curr_mat, ss_index)
  out = ss_index.posdef(curr_mat.index) == 1;
end

function out = is_pseudo_orthogonal(curr_mat, ss_index)
  out = false; % Property not available.
end

function out = is_random(curr_mat, ss_index)
  out = false; % Property not available.
end

function out = is_rank_deficient(curr_mat, ss_index)
  if curr_mat.has_svd
    m = ss_index.nrows(curr_mat.index);
    n = ss_index.ncols(curr_mat.index);
    normA = curr_mat.sigma_max;
    out = curr_mat.sigma_min > max(m, n) * eps(normA);
  else
    out = false; % Property not available for large matrices.

  end
end

function out = is_real(curr_mat, ss_index)
  out = ss_index.isReal(curr_mat.index);
end

function out = is_rectangular(curr_mat, ss_index)
  out = ss_index.nrows(curr_mat.index) ~= ss_index.ncols(curr_mat.index);
end

function out = is_scalable(curr_mat, ss_index)
  out = false;
end

function out = is_singular_values(curr_mat, ss_index)
  out = false; % Property not available.
end

function out = is_skew_hermitian(curr_mat, ss_index)
  out = false; % Property not available.
end

function out = is_skew_symmetric(curr_mat, ss_index)
  out = ss_index.RBtype(curr_mat.index, 2) == 'z';
end

function out = is_sparse(curr_mat, ss_index)
  out = true;
end

function out = is_square(curr_mat, ss_index)
  out = ss_index.nrows(curr_mat.index) == ss_index.ncols(curr_mat.index);
end

function out = is_stochastic(curr_mat, ss_index)
  out = false; % Property not available.
end

function out = is_symmetric(curr_mat, ss_index)
  out = ss_index.RBtype(curr_mat.index, 2) == 's';
end

function out = is_toeplitz(curr_mat, ss_index)
  out = false; % Property not available.
end

function out = is_totally_nonnegative(curr_mat, ss_index)
  out = false; % Property not available.
end

function out = is_totally_positive(curr_mat, ss_index)
  out = false; % Property not available.
end

function out = is_triangular(curr_mat, ss_index)
  out = ss_index.lowerbandwidth(curr_mat.index) == 0 ||...
        ss_index.upperbandwidth(curr_mat.index) == 0;
end

function out = is_tridiagonal(curr_mat, ss_index)
  out = ss_index.lowerbandwidth(curr_mat.index) == 1 &&...
        ss_index.upperbandwidth(curr_mat.index) == 1;
end

function out = is_unimodular(curr_mat, ss_index)
  out = false; % Property not available.
end

function out = is_unitary(curr_mat, ss_index)
  out = false; % Property not available.
end
