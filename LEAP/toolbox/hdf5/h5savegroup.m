function h5savegroup(filepath, S, grp, varargin)
%H5SAVEGROUP Saves a struct as a HDF5 group.
% Usage:
%   h5savegroup(filepath, S, grp)
% 
% Args:
%   filepath: path to HDF5 file to save
%   S: structure to save as an HDF5 group
%   grp: path to group (default: '/[S]' where [S] is the variable name of the struct)
%
% Params: see h5save
% 
% See also: h5readgroup, h5save

if nargin < 3; grp = inputname(2); end
if isempty(grp); grp = ''; end
if ~startsWith(grp,'/'); grp = ['/' grp]; end

fns = fieldnames(S);
isAttr = strcmp(fns,'Attributes');
fns = [fns(~isAttr); fns(isAttr)]; % move attributes to last so file is created
for i = 1:numel(fns)
    dset = [grp '/' fns{i}];
    if isstruct(S.(fns{i}))
        if strcmp(fns{i},'Attributes')
            h5struct2att(filepath, grp, S.(fns{i}))
        else
            h5savegroup(filepath, S.(fns{i}), dset, varargin{:})
        end
    else
        try
            h5save(filepath, S.(fns{i}), dset, varargin{:})
        catch
            warning('Failed to save dataset: %s', dset)
        end
    end
end

end
