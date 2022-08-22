function pkg = get_pkg_info()
% Return a struct with useful information about the suitesparse package.
  pkg.ss_url = 'https://sparse.tamu.edu';
  pkg.anymatrix_root_dir = fileparts(which('anymatrix'));
  pkg.ss_private_root_dir = fileparts(mfilename('fullpath'));
  pkg.ss_matfiles_dir = [pkg.ss_private_root_dir filesep 'matfiles'];
end