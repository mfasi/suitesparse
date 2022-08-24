function pkg = get_pkg_info()
% GET_PKG_INFO Path and URL information of Anymatrix interface to SuiteSparse.
%  PKG = GET_PKG_INFO() is a struct that contains the following four fields:
%                   PKG.SS_URL - Root URL of the SuiteSparse matrix colleciton.
%       PKG.ANYMATRIX_ROOT_DIR - Root directory of Anymatrix installation.
%      PKG.SS_PRIVATE_ROOT_DIR - Private directory of SuiteSparse group.
%           PKG.SS_MATFILE_DIR - MAT file directory of SuiteSparse group.
  pkg.ss_url = 'https://sparse.tamu.edu';
  pkg.anymatrix_root_dir = fileparts(which('anymatrix'));
  pkg.ss_private_root_dir = fileparts(mfilename('fullpath'));
  pkg.ss_matfiles_dir = [pkg.ss_private_root_dir filesep 'matfiles'];
end